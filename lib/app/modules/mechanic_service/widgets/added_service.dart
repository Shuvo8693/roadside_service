import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/home/model/mechanic_service_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_service/controllers/mechanic_service_controller.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';


import 'mechanic_service_card.dart';

class AddedServicesTab extends StatefulWidget {
  final MechanicServiceController mechanicServiceController;
  final Function(dynamic) onRemoveService;

  const AddedServicesTab({
    super.key,
    required this.mechanicServiceController,
    required this.onRemoveService,
  });

  @override
  State<AddedServicesTab> createState() => _AddedServicesTabState();
}

class _AddedServicesTabState extends State<AddedServicesTab> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await widget.mechanicServiceController.fetchServiceRate();
    });
  }

  @override
  Widget build(BuildContext context) {
   return Obx((){
      List<MechanicServiceData> mechanicServiceList = widget.mechanicServiceController.mechanicService.value.data ?? [];
      if(widget.mechanicServiceController.isLoading.value){
        return Center(child: CustomPageLoading());
      }
      if (mechanicServiceList.isEmpty) {
        return Center(child: buildEmptyDataContent(),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: mechanicServiceList.length,
        itemBuilder: (context, index) {
          final mechanicServiceData = mechanicServiceList[index];
          return MechanicServiceCard(
            service: mechanicServiceData,
            isAddedService: true,
            removeOnTap: () {
              //widget.onRemoveService(mechanicServiceData);


            },
          );
        },
      );
    });


  }

  Column buildEmptyDataContent() {
    return Column(
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
        );
  }
}