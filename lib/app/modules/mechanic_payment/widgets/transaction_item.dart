import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/views/mechanic_payment_view.dart';

class TransactionItemCard extends StatelessWidget {
  final TransactionItem transaction;

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
                Text(
                  transaction.service,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.date,
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
              _buildStatusChip(transaction.status),
              SizedBox(height: 4.h),
              Text(
                transaction.amount,
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
  Widget _buildStatusChip(TransactionStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case TransactionStatus.processing:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        text = 'Processing';
        break;
      case TransactionStatus.completed:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        text = 'Completed';
        break;
      case TransactionStatus.withdraw:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        text = 'Withdraw';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}