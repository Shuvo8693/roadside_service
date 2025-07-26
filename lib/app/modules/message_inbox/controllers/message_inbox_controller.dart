import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/modules/message_inbox/model/chat_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';
import 'package:roadside_assistance/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageInboxController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<ChatModel> chatItemList= <ChatModel>[].obs;
  late IO.Socket _socket;
  RxString receiverId = ''.obs;
  String? myID;


  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null){
      getUserId();
    }
    initSocket();
    //debounce(chatId, (_)async => await  fetchAndListenToChatHistory(),time: Duration(milliseconds: 300));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await  fetchAndListenToChatHistory();
      scrollToBottom();
    });
  }


  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 8000,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
  }
  getUserId(){
   final receiverId = Get.arguments['receiverId'];
   receiverId.value = receiverId ?? '';
   print(receiverId.value);
  }
  void initSocket() {
    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    _socket.connect();

    _socket.onConnect((_) {
      print('====Connected to server=====');
        listenToNewMessages();

    });

    _socket.onDisconnect((_) {
      print('====Disconnected from server====');
    } );
  }
  /// =====================Listen_Existing_message======================
  RxBool isLoading= false.obs;
  Future<void> fetchAndListenToChatHistory() async {
    isLoading.value=true;
    try {
      chatItemList.clear();
      List<ChatModel> fetchedMessages = await ChatService.fetchChatHistory('');
      chatItemList.assignAll(fetchedMessages);
      listenToNewMessages();
    } catch (e) {
      print("Error fetching chat history: $e");
    }finally{
      isLoading.value=false;
    }
  }

  /// ===========================Listen_New_message======================
  void listenToNewMessages() {
    _socket.off('send-message'); // Unsubscribe from any previous listeners
    _socket.on('send-message', _handleNewMessage); // Listen to the new chatId
  }

  void _handleNewMessage(dynamic data) {
    if (data != null) {
      final dataList = data as List<dynamic>;
      chatItemList.addAll(dataList.map((item) => ChatModel.fromJson(item)));
      scrollToBottom();
    } else {
      print("Received invalid message data: $data");
    }
  }
///================================================== Send_message  =======================================
  sendEmitMessage({
      required String message,
      required String receiverId,
      }) {
    Map<String, dynamic> messageData = {
      "to":receiverId,
      "message" : message
    };
    _socket.emit('send-message', messageData);
  }

  @override
  void onClose() {
    _socket.dispose();
    chatItemList.clear();
    super.onClose();
  }

}

/// =============== fetch_chat_history =================
class ChatService {
 static ChatModel chatModel = ChatModel();

static List<ChatModel> chatItemList=[];

 static Future<List<ChatModel>> fetchChatHistory(String chatRoomId) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse(''),headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
     final dataList = decodedData as List<dynamic>;
     for(var data in dataList){
       chatItemList.add(ChatModel.fromJson(data));
     }

      return chatItemList;
    } else {
      throw Exception("Failed to load chat history");
    }
  }
}


