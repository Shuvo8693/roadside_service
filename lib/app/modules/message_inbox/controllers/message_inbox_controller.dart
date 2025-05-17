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
  Rx<ChatAttributes> chatAttributes= ChatAttributes().obs;
  RxList<ChatAttributes> chatAttributesList= <ChatAttributes>[].obs;
  late IO.Socket _socket;
  RxString chatId = ''.obs;
  final ChatService _chatService = ChatService();
  String? myID;

  @override
  void onReady() async {
    super.onReady();
   // await getMyId();
    if(Get.arguments != null){
      getMessengerAttributes();
    }
    initSocket();
    await  fetchAndListenToChatHistory();
    //debounce(chatId, (_)async => await  fetchAndListenToChatHistory(),time: Duration(milliseconds: 300));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollToBottom();
    });

  }

  getMyId()async{
    String  id = await PrefsHelper.getString('userId');
    myID = id;
    update();
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
  getMessengerAttributes(){
   final messageAttributes = Get.arguments['messengerAttributes'];
   chatId.value = messageAttributes.sId??'';
  // messageAttributesMdl.value = messageAttributes;
   print(chatId.value);

  }
  void initSocket() {
    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    _socket.connect();

    _socket.onConnect((_) {
      print('====Connected to server=====');
      if (chatId.value.isNotEmpty) {
        listenToNewMessages(chatId.value);
      }
    });

    _socket.onDisconnect((_) {
      print('====Disconnected from server====');
    } );
  }
  /// =====================Listen_Existing_message======================
  RxBool isLoading= false.obs;
  Future<void> fetchAndListenToChatHistory() async {
    if (chatId.value.isEmpty) return;
    isLoading.value=true;
    try {
      chatAttributesList.clear();
      List<ChatAttributes> fetchedMessages = await _chatService.fetchChatHistory(chatId.value);
      chatAttributesList.assignAll(fetchedMessages);
      listenToNewMessages(chatId.value);
    } catch (e) {
      print("Error fetching chat history: $e");
    }finally{
      isLoading.value=false;
    }
  }

  /// ===========================Listen_New_message======================
  void listenToNewMessages(String chatId) {
    _socket.off('newMessage::$chatId'); // Unsubscribe from any previous listeners
    _socket.on('newMessage::$chatId', _handleNewMessage); // Listen to the new chatId
  }

  void _handleNewMessage(dynamic data) {
    if (data != null) {
      final dataList = data['data']['attributes'] as List<dynamic>;
      chatAttributesList.addAll(dataList.map((item) => ChatAttributes.fromJson(item)));
      scrollToBottom();
    } else {
      print("Received invalid message data: $data");
    }
  }
///================================================== Send_message  =======================================
  sendEmitMessage({
      required String message,
      required String media,
      required String messageType}) {
  //  String? senderIdMdl = messageAttributesMdl.value.participants?.firstWhere((element) => element.id == myID).id;
    Map<String, dynamic> messageData = {
      "roomId": 'messageAttributesMdl.value.sId',
      "senderId": 'senderIdMdl',
      "message": message,
      "media": media,
      "messageType": messageType
    };
    _socket.emit('send-message', messageData);
  }

  @override
  void onClose() {
    _socket.dispose();
    chatAttributesList.clear();
    super.onClose();
  }

}

/// =============== fetch_chat_history =================
class ChatService {
  ChatModel chatModel= ChatModel();

  Future<List<ChatAttributes>> fetchChatHistory(String chatRoomId) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse(''),headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      chatModel= ChatModel.fromJson(decodedData);
      /*for (var item in data['data']['attributes']['data']) {
        messages.add({
          'chatId': item['chatId'],
          'messageType': item['content']['messageType'],
          'content': item['content']['message'],
          'senderId': item['senderId']['id'],
          'id': item['id'],
        });
      }*/
      return chatModel.data?.attributes??[];
    } else {
      throw Exception("Failed to load chat history");
    }
  }
}


