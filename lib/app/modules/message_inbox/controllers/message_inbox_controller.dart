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
  RxBool isSocketConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null){
      getUserId();
    }
    _initializeChat();
    fetchChatHistoryOnly();
  }

  // Initialize chat in proper sequence
  Future<void> _initializeChat() async {
    await getUserIdFromToken();
    await initSocket();

    // Wait for socket connection before fetching chat history
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 1000,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
  }

  getUserId(){
    final receiverId = Get.arguments['receiverId'];
    receiveAbleId.value = receiverId ?? '';
    print('Receiver ID: ${receiveAbleId.value}');
  }

  Future<void> getUserIdFromToken() async {
    String token = await PrefsHelper.getString('token');
    final payload = decodeJWT(token);
    myID = payload['id'];
    print('My ID from token: $myID');
    update();
  }

  ///=========== setup socket ==================
  Future<void> initSocket() async {
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
        isSocketConnected.value = true;
        // Only setup listeners after connection is established
        listenToNewMessages();

      });

      _socket?.onDisconnect((_) {
        print('====Disconnected from server====');
        isSocketConnected.value = false;
      });

      _socket?.onConnectError((error) {
        print('Connection Error: $error');
        isSocketConnected.value = false;
      });

      // Connect to socket
      _socket?.connect();

    } catch (e) {
      print('Socket connection error: $e');
    }
  }

  /// =====================Fetch chat history only======================
  RxBool isLoading = false.obs;

  Future<void> fetchChatHistoryOnly() async {
    isLoading.value = true;
    try {
      chatItemList.clear();
      List<ChatModel> fetchedMessages = await ChatService.fetchChatHistory(
          receiverId: receiveAbleId.value
      );
      chatItemList.assignAll(fetchedMessages);

      // Scroll to bottom after loading messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });

    } catch (e) {
      print("Error fetching chat history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// =====================Listen_Existing_message======================
  Future<void> fetchAndListenToChatHistory() async {
    await fetchChatHistoryOnly();
    if (isSocketConnected.value) {
      listenToNewMessages();
    }
  }

  /// ===========================Listen_New_message======================
  void listenToNewMessages() {
    if (myID == null) {
      print('Error: myID is null, cannot listen to messages');
      return;
    }

    String eventName = 'send-message:$myID';
    String eventReceived = 'send-message:$receiveAbleId';
    print('Listening to event: $eventName');

    // Unsubscribe from any previous listeners
    _socket?.off(eventName);

    // Listen to the new chat
    _socket?.on(eventName, _handleNewMessage);

  }

  void _handleNewMessage(dynamic data) {
    print('Received new message: $data');

    if (data != null) {
      try {
        //chatItemList.clear();
        ChatModel newMessage = ChatModel.fromJson(data);
        chatItemList.add(newMessage);

        // Scroll to bottom when new message arrives
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });

      } catch (e) {
        print("Error parsing new message: $e");
      }
    } else {
      print("Received invalid message data: $data");
    }
  }

  ///================================================== Send_message =======================================

  void sendEmitMessage({
    required String message,
    required String receiverId,
  }) {
    if (!isSocketConnected.value) {
      print('Socket not connected, cannot send message');
      return;
    }

    Map<String, dynamic> messageData = {
      "to": receiverId,
      "message": message
    };

    print('Sending message: $messageData');
    _socket?.emit('send-message', messageData);
  }

  void disposeSocket() {
    if (myID != null) {
      _socket?.off('send-message:$myID');
    }
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
  static Future<List<ChatModel>> fetchChatHistory({String? receiverId}) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.chatHistoryUrl(receiverId ?? '')}'),
        headers: headers
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final dataList = decodedData['data'] as List<dynamic>;

      List<ChatModel> chatItemList = [];
      for (var data in dataList) {
        chatItemList.add(ChatModel.fromJson(data));
      }

      return chatItemList;
    } else {
      throw Exception("Failed to load chat history");
    }
  }
}