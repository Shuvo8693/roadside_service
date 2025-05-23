import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/mechanic_service/controllers/mechanic_service_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_service/widgets/mechanic_service_card.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

class MechanicServiceView extends StatefulWidget {
  const MechanicServiceView({super.key});

  @override
  State<MechanicServiceView> createState() => _MechanicServiceViewState();
}

class _MechanicServiceViewState extends State<MechanicServiceView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MechanicServiceController _mechanicServiceController =Get.put(MechanicServiceController());


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  // bool? isAdded;

  // checkAddedService(){
  //   final isAdd = _mechanicServiceController.addedServices.contains(widget.service);
  //   // isAdded = isAdd;
  // }
  void _addService(ServiceItem service) {
    setState(() {
      if (!_mechanicServiceController.addedServices.contains(service)) {
        _mechanicServiceController.addedServices.add(service);
      }
      //checkAddedService();
    });
  }

  void _removeService(ServiceItem service) {
    setState(() {
      _mechanicServiceController.addedServices.remove(service);
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Service',
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
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r),topRight: Radius.circular(8.r)),

              ),
              tabs: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'All Service',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Added Service',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllServicesTab(),
                _buildAddedServicesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// All Service list
  Widget _buildAllServicesTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _mechanicServiceController.allServices.length,
      itemBuilder: (context, index) {
        final service = _mechanicServiceController.allServices[index];
        final isAdded = _mechanicServiceController.addedServices.contains(service);
        return MechanicServiceCard(
          service: service,
          isAdded: isAdded,
          addOnTap: (){
           _addService(service);
          },
        );
      },
    );
  }
  /// Added Service list
  Widget _buildAddedServicesTab() {
    if (_mechanicServiceController.addedServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No services added yet',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add services from the All Service tab',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
 /// Added Service list
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _mechanicServiceController.addedServices.length,
      itemBuilder: (context, index) {
        final service = _mechanicServiceController.addedServices[index];
        return MechanicServiceCard(
          service: service,
          isAddedService: true,
          removeOnTap:(){
            _removeService(service);
          } ,
        );
      },
    );
  }
}



class ServiceItem {
  final String name;
  final String icon;
  late final double price;
  final Color iconColor;
  final TextEditingController priceTEC;

  ServiceItem({
    required this.name,
    required this.icon,
    required this.price,
    required this.iconColor,
  }): priceTEC = TextEditingController(text: price.toString());

  double get totalPrice => price + ( price * 0.2) ;

  void updatePrice(String value) {
    final newPrice = double.tryParse(value);
    if (newPrice != null && newPrice >= 0) {
      price = newPrice;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ServiceItem &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;
}