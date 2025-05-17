import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class SendMessageController extends GetxController {
  RxString commentMessage = ''.obs;
  File? selectedIFile;
  var filePath=''.obs;
  RxBool isLoading=false.obs;

  sendMessage(Callback onDone,String filePath,String chatRoomId) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    Map<String, String> body = {
      'chatid': chatRoomId,
    };
    isLoading.value=true;
    var request =  http.MultipartRequest('POST', Uri.parse(''));
    request.fields.assignAll(body);

    File fileData = File(filePath);

    try {
      // Determine file type and add it to the request
      if(fileData.path.isNotEmpty){
        await _addFileToRequest(request, fileData);
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var responseData = jsonDecode(responseBody);
      if (response.statusCode == 201) {
        onDone();
        commentMessage.value = responseData['message'];
        print("Response Success (201): $responseBody");
      } else {
        var errorData = jsonDecode(responseBody);
        commentMessage.value = errorData['message'] ?? 'Something went wrong';
        print("Response Error (${response.statusCode}): $responseBody");
        Get.snackbar('Failed', commentMessage.value);
      }
    } on Exception catch (e) {
      print(e.toString());
      commentMessage.value = 'An error occurred while uploading the file.';
      Get.snackbar('Failed', commentMessage.value);
    }finally{
      isLoading.value=false;
    }
  }

  pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    selectedIFile = File(returnImage.path);
    filePath.value=selectedIFile!.path;
    print('ImagesPath:$filePath');
    if(filePath.value.isNotEmpty){
      Get.snackbar('File selected', '');
    }
  }

  // Helper method to add file based on its type
  _addFileToRequest(http.MultipartRequest request, File file) async {
    String fileName = file.path.split('/').last;
    String fileType = fileName.split('.').last.toLowerCase();

    if (fileType == 'png') {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await file.readAsBytes(),
        filename: fileName,
        contentType: MediaType('image', 'png'),
      ));
      debugPrint("Media type png ==== $fileName");
    }
    if (fileType == 'jpg' || fileType == 'jpeg') {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await file.readAsBytes(),
        filename: fileName,
        contentType: MediaType('image', fileType),
       ),
      );
      debugPrint("Media type $fileType ==== $fileName");
    } else {
      debugPrint("Unsupported media type: $fileName");
      throw Exception('Unsupported file type');
    }
  }


}
