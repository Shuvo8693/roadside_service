import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';

class AddVehicleView extends StatefulWidget {
  const AddVehicleView({super.key});

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  List<Map<String, String>> vehicles = [];
  @override
  void dispose() {
    _modelController.dispose();
    _brandController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add Vehicle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Vehicle Model
            Text(
              'Vehicle Model',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              contentPaddingVertical: 15.h,
              controller: _modelController,
              hintText: 'Enter Vehicle Model',
            ),

            SizedBox(height: 16.h),
            // Vehicle Brand
            Text(
              'Vehicle Brand',
              style: TextStyle(

                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              contentPaddingVertical: 15.h,
              controller: _brandController,
              hintText: 'Enter Vehicle Brand',
            ),

            SizedBox(height: 16.h),
            // Vehicle Number
            Text(
              'Vehicle Number',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              contentPaddingVertical: 15.h,
              controller: _numberController,
              hintText: 'Enter Vehicle number',
            ),

            const Spacer(),
            /// Add Now Button
            CustomButton(
              text: 'Add Now',
              onTap: () {
                vehicles.addAll([{'model': 'Shuvokh', 'brand': 'SHUVO', 'number': '1254-22-1145'}]);
                Get.back(result: vehicles);
              },
              width: double.infinity,
              height: 50.h,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}