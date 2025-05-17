import 'package:get/get.dart';

import 'package:roadside_assistance/app/modules/message_inbox/controllers/message_inbox_controller.dart';
import 'package:roadside_assistance/app/modules/message_inbox/controllers/send_message_controller.dart';

class MessageInboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageInboxController>(
      () => MessageInboxController(),
    );

    Get.lazyPut<SendMessageController>(
      () => SendMessageController(),
    );
  }
}
