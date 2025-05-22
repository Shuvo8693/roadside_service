import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/widgets/withdraw_dialouge.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';

class MechanicPaymentView extends StatefulWidget {
  const MechanicPaymentView({super.key});

  @override
  State<MechanicPaymentView> createState() => _MechanicPaymentViewState();
}

class _MechanicPaymentViewState extends State<MechanicPaymentView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
 final List<Tab>_tapBarList= [
    Tab(text: 'All'),
    Tab(text: 'Processed'),
    Tab(text: 'Completed'),
    Tab(text: 'Withdraw'),
  ];

  /// Sample data
  final List<TransactionItem> _allTransactions = [
    TransactionItem(
      service: 'Towing Service',
      date: 'Oct 15,2025, 2:30 PM',
      amount: '\$76.00',
      status: TransactionStatus.processing,
    ),
    TransactionItem(
      service: 'Towing Service',
      date: 'Oct 15,2025, 2:30 PM',
      amount: '\$76.00',
      status: TransactionStatus.processing,
    ),
    TransactionItem(
      service: 'Towing Service',
      date: 'Oct 15,2025, 2:30 PM',
      amount: '\$76.00',
      status: TransactionStatus.completed,
    ),
    TransactionItem(
      service: 'Towing Service',
      date: 'Oct 15,2025, 2:30 PM',
      amount: '\$76.00',
      status: TransactionStatus.completed,
    ),
    TransactionItem(
      service: 'Towing Service',
      date: 'Oct 14,2025, 1:15 PM',
      amount: '\$85.00',
      status: TransactionStatus.withdraw,
    ),
    TransactionItem(
      service: 'Towing Service',
      date: 'Oct 13,2025, 3:45 PM',
      amount: '\$92.00',
      status: TransactionStatus.withdraw,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// todo =========== Need Refactor ============
    return Scaffold(
       bottomNavigationBar: BottomMenu(2),
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Earnings Summary Cards
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: _buildEarningsCard(
                    '\$9909.50',
                    'Total Earnings',
                    Colors.blue[100]!,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildEarningsCard(
                    '\$5614',
                    'Available',
                    Colors.blue[100]!,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildEarningsCard(
                    '\$314',
                    'Withdraw',
                    Colors.blue[100]!,
                  ),
                ),
              ],
            ),
          ),

          /// Payment Method Section
          Container(
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
                  onTap: () {
                    // Handle add payment details
                  },
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
                    onTap: (){
                    showWithdrawDialog(
                        context,
                        availableBalance: 13500,
                        onWithdraw: (amount){
                         Get.snackbar('Withdrawal request for \$${amount.toStringAsFixed(2)} submitted','');
                       });
                    }, text: '\$ Withdraw Fund')
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // TabBar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              dividerColor: Colors.white,
              indicatorWeight: 2.h,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: _tapBarList,
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(_allTransactions),
                _buildTransactionList(_getTransactionsByStatus(TransactionStatus.processing)),
                _buildTransactionList(_getTransactionsByStatus(TransactionStatus.completed)),
                _buildTransactionList(_getTransactionsByStatus(TransactionStatus.withdraw)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard(String amount, String label, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionItem> transactions) {
    if (transactions.isEmpty) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: 48.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                'No transactions found',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return _buildTransactionItem(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionItem(TransactionItem transaction) {
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

  List<TransactionItem> _getTransactionsByStatus(TransactionStatus status) {
    return _allTransactions.where((transaction) => transaction.status == status).toList();
  }
}

// Models
enum TransactionStatus { processing, completed, withdraw }

class TransactionItem {
  final String service;
  final String date;
  final String amount;
  final TransactionStatus status;

  TransactionItem({
    required this.service,
    required this.date,
    required this.amount,
    required this.status,
  });
}