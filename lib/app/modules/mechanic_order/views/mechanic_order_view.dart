import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/widgets/orderlist.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';


class MechanicOrderView extends StatefulWidget {
  const MechanicOrderView({super.key});

  @override
  State<MechanicOrderView> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<MechanicOrderView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
     List<String> _tabs = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabs = ['New(${8})', 'Progress(${7})', 'Completed(${3})'];
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Order'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Custom Tab Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            color: Colors.white,
            child: Row(
              children: List.generate(_tabs.length, (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                        _tabController.animateTo(index);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(_tabs[index],
                        style: TextStyle(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ).expand((widget) => [widget, SizedBox(width: 8.w)]).toList()..removeLast(),
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // New Orders Tab
                OrdersList(orders: generateDummyOrders(3,'Pending'), tapIndex: 0,),

                // In Progress Tab
                OrdersList(orders: generateDummyOrders(2,'Progress'), tapIndex: 1,),

                // Completed Tab
                OrdersList(orders: generateDummyOrders(1,'Completed'), tapIndex: 2,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<OrderModel> generateDummyOrders(int length,String status) {
    return List.generate(length, (index) => OrderModel(
        customerName: 'Sarah Johnson',
        distance: '2.5 Km Away',
        status: status,
        price: 76,
        service: 'Towing',
        carType: 'Suzuki. Maruti. 23-323-22',
      ),
    );
  }
}





class OrderModel {
  final String customerName;
  final String distance;
  final String status;
  final int price;
  final String service;
  final String carType;

  OrderModel({
    required this.customerName,
    required this.distance,
    required this.status,
    required this.price,
    required this.service,
    required this.carType,
  });
}