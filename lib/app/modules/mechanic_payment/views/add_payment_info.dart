import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';

class AddPaymentInfoView extends StatefulWidget {
  const AddPaymentInfoView({super.key});

  @override
  State<AddPaymentInfoView> createState() => _AddPaymentInfoViewState();
}

class _AddPaymentInfoViewState extends State<AddPaymentInfoView> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24.sp,
          ),
        ),
        title: Text(
          'Add Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Main content card
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    CustomButton(onTap: (){
                      _handleSave();
                    }, text: 'Save')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    // Validate inputs
    if (_bankNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter bank name');
      return;
    }

    if (_accountHolderController.text.trim().isEmpty) {
      _showSnackBar('Please enter account holder name');
      return;
    }

    if (_accountNumberController.text.trim().isEmpty) {
      _showSnackBar('Please enter account number');
      return;
    }

    // TODO: Implement save logic here
    // For example: call API, save to database, etc.

    _showSnackBar('Payment method saved successfully');

    // Navigate back or to next screen
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('successfully')
            ? Colors.green
            : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}