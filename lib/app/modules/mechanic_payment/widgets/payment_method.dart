import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';

class PaymentMethodWidget extends StatelessWidget {
  final VoidCallback onAddPaymentDetails;
  final VoidCallback onWithdrawFund;

  const PaymentMethodWidget({
    super.key,
    required this.onAddPaymentDetails,
    required this.onWithdrawFund,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: onAddPaymentDetails,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Payment Details',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.black87,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          /// Withdraw Fund Button
          CustomButton(
            height: 45.h,
            onTap: onWithdrawFund,
            text: '\$ Withdraw Fund',
          ),
        ],
      ),
    );
  }
}