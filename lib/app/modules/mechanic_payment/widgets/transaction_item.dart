import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/model/payment_status_model.dart';

class TransactionItemCard extends StatelessWidget {
  final PaymentRequest transaction;

  const TransactionItemCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // service
                Text(
                  transaction.id??'',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                // Date
                SizedBox(height: 4.h),
                Text(
                  transaction.createdAt.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatusChip(transaction.status??''),
              // amount
              SizedBox(height: 4.h),
              Text(
                transaction.amount.toString(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildStatusChip(String status) {
    Color? backgroundColor;
    Color? textColor;
    String? text;

    switch (status) {
      case 'processing':
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        text = 'Processing';
        break;
      case 'completed':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        text = 'Completed';
        break;
      case 'withdrawn':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        text = 'Withdrawn';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text??'',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}