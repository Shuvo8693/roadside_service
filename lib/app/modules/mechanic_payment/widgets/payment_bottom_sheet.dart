import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/model/payment_method_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/views/payment_method.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';

class AddPaymentBottomSheet extends StatefulWidget {
  final Function(PaymentMethod) onAddPayment;
    final RxBool isLoading ;

   const AddPaymentBottomSheet({super.key, required this.onAddPayment, required this.isLoading});

  @override
  State<AddPaymentBottomSheet> createState() => _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends State<AddPaymentBottomSheet> {

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            // Bank Name
            Text(
              'Bank Name',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              controller: _bankNameController,
              hintText: 'Enter Bank Name',
              contentPaddingVertical: 15.h,
            ),

            SizedBox(height: 24.h),

            // Account Holder Name
            Text(
              'Account Holder Name',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              controller: _accountHolderController,
              hintText: 'Enter Account Holder Name',
              contentPaddingVertical: 15.h,
            ),
            SizedBox(height: 24.h),
            // Account Number
            Text(
              'Account Number',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              controller: _accountNumberController,
              hintText: '38938*8888**',
              keyboardType: TextInputType.number,
              contentPaddingVertical: 15.h,
            ),

            SizedBox(height: 32.h),

            // Save Button
            Obx((){
              return  CustomButton(
                loading: widget.isLoading.value,
                  onTap: (){
                    if (_accountNumberController.text.isNotEmpty &&
                        _accountHolderController.text.isNotEmpty && _bankNameController.text.isNotEmpty) {
                      widget.onAddPayment(
                        PaymentMethod(
                          accountNumber: _accountNumberController.text,
                          accountHolderName: _accountHolderController.text,
                          bankName: _bankNameController.text,
                        ),
                      );
                      Navigator.pop(context);
                    }
                    // _handleSave();
                  }, text: 'Save');
            }

            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}