import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/mechanic_service/controllers/mechanic_service_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_service/views/mechanic_service_view.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

class MechanicServiceCard extends StatelessWidget {
  const MechanicServiceCard({
    super.key,
    required this.service,
     this.isAddedService =false, this.removeOnTap, this.addOnTap, this.isAdded,
  });

  final ServiceItem service;
  final bool isAddedService;
  final bool? isAdded;
  final VoidCallback? removeOnTap;
  final VoidCallback? addOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  service.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                verticalSpacing(8.h),
                SvgPicture.asset(service.icon),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Price',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                verticalSpacing(isAddedService? 15.h:8.h),
                isAddedService
                    ? Text(
                      '${service.price}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                          fontWeight: FontWeight.w600
                      ),
                    )
                    : SizedBox(
                      width: 65.w,
                      child: CustomTextField(
                        contentPaddingHorizontal: 12.w,
                        contentPaddingVertical: 10.h,
                        controller: service.priceTEC,
                      ),
                    ),
              ],
            ),
          ),
          Expanded(
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '(20% Commission)',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.grey[500],
                  ),
                ),
                verticalSpacing(8.h),
                Text(
                  '\$${(service.totalPrice).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          isAddedService
              ? CustomButton(
          width: 70.w,
          height: 40.h,
           color: Colors.red,
           textStyle: TextStyle(fontSize: 11.sp,color: Colors.white),
           onTap: removeOnTap??(){}, text: 'Remove')
              : SizedBox(
            width: 75.w,
            child: ElevatedButton(
              onPressed: isAdded==true ? null  :addOnTap ?? (){} ,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdded==true ? Colors.grey[300] : Colors.blue,
                foregroundColor: isAdded==true ? Colors.grey[600] : Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                isAdded == true ? 'Added' : 'Add',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}