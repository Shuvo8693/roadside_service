import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/account/controllers/account_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/controllers/mechanic_home_controller.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';

class MechanicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AccountController accountController;
  final MechanicHomeController mechanicHomeController;

  const MechanicAppBar({
    super.key,
    required this.accountController,
    required this.mechanicHomeController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CircleAvatar(
        radius: 24.r,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: Obx(() {
            String? imageUrl =
                accountController.profileModel.value.data?.user?.image;
            return CustomNetworkImage(
              imageUrl: imageUrl ?? '',
              width: 48.r,
              height: 48.r,
              boxFit: BoxFit.cover,
            );
          }),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name
          Obx(() {
            String? name =
                accountController.profileModel.value.data?.user?.name;
            return Text(
              name ?? '',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            );
          }),

          /// Title
          Obx(() {
            String? title =
                accountController.profileModel.value.data?.user?.role;
            return Text(
              title ?? 'Mechanic',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            );
          }),
        ],
      ),
      actions: [
        Row(
          children: [
            /// Status
            Obx(() {
              bool isAvailable = mechanicHomeController.isAvailability.value;
              return Text(
                isAvailable ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isAvailable ? Colors.green : Colors.grey,
                ),
              );
            }),
            SizedBox(width: 8.w),
            Transform.scale(
              scale: 0.8,
              child: Obx(() {
                String? userId =
                    accountController.profileModel.value.data?.user?.id;
                bool isAvailable = mechanicHomeController.isAvailability.value;
                return Switch(
                  activeColor: Colors.green,
                  value: isAvailable,
                  onChanged: (value) async {
                    // Handle status change
                    await mechanicHomeController.changeAvailability(
                      mechanicId: userId ?? '',
                    );
                  },
                );
              }),
            ),
            SizedBox(width: 8.w), // Add some padding from the edge
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
