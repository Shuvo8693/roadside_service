import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> paymentMethods = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Payments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),

            // Payment Methods List
            if (paymentMethods.isNotEmpty) ...[
              ...paymentMethods.map((method) => _buildPaymentMethodCard(method)),
              SizedBox(height: 16.h),
            ],

            // Add Payment Details Button
            GestureDetector(
              onTap: _showAddPaymentBottomSheet,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Payment Details',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      size: 24.sp,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Bank Icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.account_balance,
              size: 20.sp,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 12.w),

          // Bank Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.bankName??'Bank',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  method.cardNumber,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              GestureDetector(
                onTap: () => _viewPaymentMethod(method),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'View',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => _removePaymentMethod(method),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddPaymentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddPaymentBottomSheet(
        onAddPayment: (method) {
          setState(() {
            paymentMethods.add(method);
          });
        },
      ),
    );
  }
 /// view payment details at AlertDialogue
  void _viewPaymentMethod(PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Method Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: Bank'),
            SizedBox(height: 8.h),
            Text('Bank Name: ${method.bankName}'),
            SizedBox(height: 8.h),
            Text('Card Number: ${method.cardNumber}'),
            SizedBox(height: 8.h),
            Text('Holder Name: ${method.holderName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _removePaymentMethod(PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Payment Method'),
        content: Text('Are you sure you want to remove this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                paymentMethods.remove(method);
              });
              Navigator.pop(context);
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _AddPaymentBottomSheet extends StatefulWidget {
  final Function(PaymentMethod) onAddPayment;

  const _AddPaymentBottomSheet({required this.onAddPayment});

  @override
  State<_AddPaymentBottomSheet> createState() => _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends State<_AddPaymentBottomSheet> {

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
            CustomButton(
                onTap: (){
                  if (_accountNumberController.text.isNotEmpty &&
                      _accountHolderController.text.isNotEmpty && _bankNameController.text.isNotEmpty) {
                    widget.onAddPayment(
                      PaymentMethod(
                        cardNumber: '****${_accountNumberController.text.substring(_accountNumberController.text.length - 4)}',
                        holderName: _accountHolderController.text,
                        bankName: _bankNameController.text,
                      ),
                    );
                    Navigator.pop(context);
                  }
              // _handleSave();
            }, text: 'Save'),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class PaymentMethod {
  final String cardNumber;
  final String holderName;
  final String bankName;

  PaymentMethod({
    required this.cardNumber,
    required this.holderName,
    required this.bankName,
  });
}
