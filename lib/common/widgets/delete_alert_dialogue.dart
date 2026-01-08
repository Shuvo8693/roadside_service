import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/common/app_string/app_string.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

import '../../app/modules/account/controllers/account_controller.dart';
import '../../app/routes/app_pages.dart';
import 'custom_button.dart';
import 'custom_outlinebutton.dart';

class DeleteAlertDialogue extends StatelessWidget {
  const DeleteAlertDialogue({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final accountController = Get.find<AccountController>();
    return AlertDialog(
      title: Text(AppString.deleteText),
      content: Text(AppString.areYouSureYouDeleteText),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 5,
              child: horizontalSpacing(10.w),
            ),
            Expanded(
              flex: 5,
              child: CustomOutlineButton(
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                text: "No",
              ),
            ),
            horizontalSpacing(10.w),
            Expanded(
              flex: 5,
              child: Obx(() {
                return CustomButton(
                  loading: accountController.isDeleteLoading.value,
                  color: Colors.redAccent,
                  onTap: () async {
                    // Perform delete operation here
                    await accountController.deleteAccount();
                  },
                  text: "Yes",
                );
              }
              ),
            ),
          ],
        ),
      ],
    );
  }
}