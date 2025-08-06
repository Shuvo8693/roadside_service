import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:roadside_assistance/app/modules/message_inbox/controllers/message_inbox_controller.dart';
import 'package:roadside_assistance/app/modules/message_inbox/model/chat_model.dart' show ChatModel;
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/date_time_formation/data_age_formation.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';

import '../controllers/send_message_controller.dart';

class MessageInboxView extends StatefulWidget {
  const MessageInboxView({super.key});

  @override
  State<MessageInboxView> createState() => _MessageInboxViewState();
}

class _MessageInboxViewState extends State<MessageInboxView> {
  final TextEditingController _msgCtrl = TextEditingController();
  final SendMessageController _sendMessageController = Get.put(SendMessageController());
  final MessageInboxController _messageInboxController = Get.put(MessageInboxController());
  String? messageType;
  String? tournamentCreatorId;
  String? roomChatId;

 // @override
 //  void initState() {
 //    super.initState();
 //    if(Get.arguments != null){
 //      _messageInboxController.getUserId();
 //    }
 //    _messageInboxController.getUserIdFromToken();
 //    _messageInboxController.initSocket();
 //    //debounce(receiveAbleId, (_)async => await  fetchAndListenToChatHistory(),time: Duration(milliseconds: 300));
 //    WidgetsBinding.instance.addPostFrameCallback((_) async {
 //      await  _messageInboxController.fetchAndListenToChatHistory();
 //      _messageInboxController.scrollToBottom();
 //    });
 //  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set to true so the body automatically adjusts when keyboard appears
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(() {
                 List<ChatModel> chatAttributesList = _messageInboxController.chatItemList;
                  if (_messageInboxController.isLoading.value) {
                    return Center(child: CustomPageLoading());
                  } else if (chatAttributesList.isEmpty) {
                    return Center(child: Text('No Message'));
                  }
                  return ListView.builder(
                    // reverse: false,// Start from the bottom
                    controller: _messageInboxController.scrollController,
                    padding: EdgeInsets.only(bottom: 10.h),
                    itemCount: chatAttributesList.length,
                    itemBuilder: (context, index) {
                      print(_messageInboxController.myID);
                      final chatAttributesIndex = chatAttributesList[index];
                      print(chatAttributesIndex);

                      if (chatAttributesIndex.sender == _messageInboxController.myID ) {
                        return senderBubble(context, chatAttributesIndex);
                      } else  {
                        return receiverBubble(context, chatAttributesIndex);
                      }
                      return SizedBox.shrink();
                    },
                  );
                }),
              ),
            ),

            // Message input bar - fixed at bottom
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 10,
                  bottom: 10 + MediaQuery.of(context).padding.bottom),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      contentPaddingVertical: 15.h,
                      hintText: 'Send Message',
                      controller: _msgCtrl,
                      suffixIcon: InkWell(
                        onTap: tournamentCreatorId.toString() == _messageInboxController.myID && messageType == 'group' ? () async {
                          await _sendMessageController.pickImageFromGallery();
                           }:messageType == 'single'?()async{
                          await _sendMessageController.pickImageFromGallery();
                        }: null ,
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: SvgPicture.asset(
                            AppIcons.fileIcon,
                            height: 16.h,
                            width: 16.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  /// =========== Show selected Image ==========
                  SizedBox(width: 8.w),
                  Obx((){
                    String filePath = _sendMessageController.filePath.value;
                    if(filePath.isNotEmpty){
                      return  Container(
                        height: 55.h,
                        width: 52.w,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                            image: DecorationImage(image: FileImage(filePath.isNotEmpty?File(filePath):File('')),fit: BoxFit.cover))
                      );
                    }else{
                      return SizedBox.shrink();
                    }
                  }
                  ),
                  /// =========== Send message ================
                  SizedBox(width: 8.w),
                  Obx((){
                   String receiverId = _messageInboxController.receiveAbleId.value;
                    return CustomButton(
                      height: 55.h,
                      width: 52.w,
                      onTap: () {
                        if (_msgCtrl.text.isNotEmpty) {
                          try {
                             _messageInboxController.sendEmitMessage(
                              message: _msgCtrl.text,
                              receiverId: receiverId, ///==================== receiver id
                            );
                            _msgCtrl.clear();
                           // _messageInboxController.scrollToBottom();
                          } catch (e) {
                            Get.snackbar('Error', 'Failed to send message: $e');
                          }
                        }
                      }, text: 'Send',
                    );
                  }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sent Message bubble
  Widget senderBubble(BuildContext context, ChatModel chatAttributes) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
            alignment: Alignment.topRight,
            margin:  EdgeInsets.only(top: 20.h, bottom: 20.w),
            backGroundColor: AppColors.primaryColor,
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.57),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showMessage(chatAttributes),
                  Text(
                    DateAgeFormation().formatAge(chatAttributes.timestamp!),
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        CustomNetworkImage(
          imageUrl: _messageInboxController.myID == chatAttributes.sender? "${chatAttributes.senderImage}" : "${chatAttributes.receiverImage}",
          height: 40.h,
          width: 40.w,
          boxShape: BoxShape.circle,
        ),
      ],
    );
  }

  /// Receive Message bubble
  Widget receiverBubble(BuildContext context, ChatModel chatAttributes) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomNetworkImage(
          imageUrl: _messageInboxController.myID == chatAttributes.receiver ?  "${chatAttributes.receiverImage}" : "${chatAttributes.senderImage}",
          height: 40.h,
          width: 40.w,
          boxShape: BoxShape.circle,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
            margin:  EdgeInsets.only(top: 20.h, bottom: 20.h),
            backGroundColor: const Color(0xff1E66CA).withOpacity(0.10),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.57),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showMessage(chatAttributes),
                  Text(
                    DateAgeFormation().formatAge(chatAttributes.timestamp!),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6), fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Show message based on type
  Widget showMessage(ChatModel chatAttributes) {
     return Text(
      '${chatAttributes.message}',
      style: TextStyle(
          color: chatAttributes.sender == _messageInboxController.myID
              ? Colors.white
              : Colors.black),
      textAlign: TextAlign.start,
    );
  }

}
