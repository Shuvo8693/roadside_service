import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';

class WithdrawDialog extends StatefulWidget {
  final double availableBalance;
  final Function(double amount)? onWithdraw;

  const WithdrawDialog({
    super.key,
    required this.availableBalance,
    this.onWithdraw,
  });

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool _isValidAmount = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = '0.00';
    _amountController.addListener(_validateAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validateAmount() {
    final text = _amountController.text.replaceAll('\$', '').replaceAll(',', '');
    final amount = double.tryParse(text) ?? 0.0;
    setState(() {
      _isValidAmount = amount > 0 && amount <= widget.availableBalance;
    });
  }

  void _onRequest() {
    if (_isValidAmount) {
      final text = _amountController.text.replaceAll('\$', '').replaceAll(',', '');
      final amount = double.tryParse(text) ?? 0.0;
      widget.onWithdraw?.call(amount);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Balance',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '\$${widget.availableBalance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},',)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Amount to Withdraw Label
            Text(
              'Amount to Withdraw',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 12.h),
            // Amount Input Field
            CustomTextField(
                controller: _amountController,
                contentPaddingVertical: 10.h,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
            ),

            /// Error message for invalid amount
            if (!_isValidAmount && _amountController.text != '0.00' && _amountController.text.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  'Amount must be greater than \$0.00 and not exceed available balance',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.red[600],
                  ),
                ),
              ),

            SizedBox(height: 32.h),

            /// Request Button
            CustomButton(
              height: 48.h,
                onTap: _isValidAmount ? _onRequest : (){} , text: 'Request',
              color: _isValidAmount ? AppColors.primaryColor : Colors.grey[300],
              textStyle: TextStyle(
                color: _isValidAmount ? Colors.white : Colors.grey[600],
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom input formatter for currency
class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '0.00');
    }

    // Remove any non-digit characters except decimal point
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Handle multiple decimal points
    if (digitsOnly.split('.').length > 2) {
      digitsOnly = digitsOnly.substring(0, digitsOnly.lastIndexOf('.'));
    }

    // Limit to 2 decimal places
    if (digitsOnly.contains('.')) {
      List<String> parts = digitsOnly.split('.');
      if (parts[1].length > 2) {
        parts[1] = parts[1].substring(0, 2);
        digitsOnly = '${parts[0]}.${parts[1]}';
      }
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

// Helper function to show the dialog
void showWithdrawDialog(BuildContext context, {
  required double availableBalance,
  Function(double amount)? onWithdraw,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return WithdrawDialog(
        availableBalance: availableBalance,
        onWithdraw: onWithdraw,
      );
    },
  );
}
