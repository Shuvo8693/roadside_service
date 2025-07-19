import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/controllers/payment_method_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/model/payment_method_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/widgets/payment_bottom_sheet.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/widgets/payment_method_card.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final PaymentMethodController _paymentMethodController = Get.put(PaymentMethodController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _paymentMethodController.fetchPaymentMethod();
    });
  }

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

            /// Payment Methods List
            Obx((){
              List<PaymentMethod> paymentMethods = _paymentMethodController.paymentMethodResponse.value.data??[];
                 if(paymentMethods.isNotEmpty){
                  return Column(
                    children: [
                      ...paymentMethods.map((method) => PaymentMethodCard(
                        method: method,
                        viewButton: ()=> _viewPaymentMethod(method),
                        removeButton: ()=> _removePaymentMethod(method),
                      ),
                      ),
                      SizedBox(height: 16.h),
                   ],
                  );
                 }
              return SizedBox.shrink();
            }),

            /// Add Payment Details Button
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

  void _showAddPaymentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPaymentBottomSheet(
        onAddPayment: (method)async {
        await _paymentMethodController.addPaymentMethod(paymentBody: PaymentBody(method.bankName, method.accountHolderName, method.accountNumber));
        }, isLoading: _paymentMethodController.isLoading2,
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
            Text('A/C Number: ${method.accountNumber}'),
            SizedBox(height: 8.h),
            Text('Holder Name: ${method.accountHolderName}'),
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
            onPressed: () async {
            await _paymentMethodController.removePaymentMethod(paymentMethodId: method.id,callBack: (){
              _paymentMethodController.paymentMethodResponse.update((model)=>model?.data?.removeWhere((data)=>data.id == method.id));
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

