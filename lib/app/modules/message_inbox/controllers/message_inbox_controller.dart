import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/modules/message_inbox/model/chat_model.dart';
import 'package:roadside_assistance/common/jwt_decoder/jwt_decoder.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';
import 'package:roadside_assistance/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageInboxController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<ChatModel> chatItemList= <ChatModel>[].obs;
   IO.Socket? _socket;
  RxString receiveAbleId = ''.obs;
  String? myID;


  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null){
      getUserId();
    }
    getUserIdFromToken();
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
   receiveAbleId.value = receiverId ?? '';
   print(receiveAbleId.value);
  }


  getUserIdFromToken()async{
    String token = await PrefsHelper.getString('token');
    final payload = decodeJWT(token);
    print(payload['id']);
      myID = payload['id'];
      update();
  }

  ///=========== setup socket ==================
   initSocket() async{
    String token = await PrefsHelper.getString('token');
    try {
      Map<String, dynamic> options = {
        'transports': ['websocket'],
        'autoConnect': false,
      };

      // Add token to headers if provided
      if (token.isNotEmpty) {
        options['extraHeaders'] = {
          'token': token,
        };
      }

      _socket = IO.io(ApiConstants.baseUrl, options);

      _socket?.onConnect((_) {
        print('====Connected to server=====');
        listenToNewMessages();
      });

      // Setup listeners before connecting
      if (_socket?.connected != true) {
        _socket?.connect();
      }

      _socket?.onDisconnect((_) {
        print('====Disconnected from server====');
      } );

    } catch (e) {
      print('Socket connection error: $e');
    }
  }

  /// =====================Listen_Existing_message======================
  RxBool isLoading= false.obs;
  Future<void> fetchAndListenToChatHistory() async {
    isLoading.value=true;
    try {
      chatItemList.clear();
      List<ChatModel> fetchedMessages = await ChatService.fetchChatHistory(receiverId:receiveAbleId.value );
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
    _socket?.off('send-message'); // Unsubscribe from any previous listeners
    _socket?.on('send-message', _handleNewMessage); // Listen to the new chat
  }

  void _handleNewMessage(dynamic data) {
    if (data != null) {
      chatItemList.add(ChatModel.fromJson(data));
      print(chatItemList);
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
    _socket?.emit('send-message', messageData);
  }

  void disposeSocket() {
    _socket?.disconnect();
    _socket?.dispose();
  }

  @override
  void onClose() {
    disposeSocket();
    chatItemList.clear();
    super.onClose();
  }

}

/// =============== fetch_chat_history =================
class ChatService {
 static ChatModel chatModel = ChatModel();

static List<ChatModel> chatItemList = [];

 static Future<List<ChatModel>> fetchChatHistory({String? receiverId}) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.chatHistoryUrl(receiverId??'')}'),headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
     final dataList = decodedData['data'] as List<dynamic>;
     for(var data in dataList){
       chatItemList.add(ChatModel.fromJson(data));
     }

      return chatItemList;
    } else {
      throw Exception("Failed to load chat history");
    }
  }
}


