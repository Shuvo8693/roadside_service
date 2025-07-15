import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/modules/home/controllers/home_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_service/controllers/mechanic_service_controller.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';

import '../../home/model/mechanic_service_model.dart';
import 'mechanic_service_card.dart';

class AllServices extends StatefulWidget {
  final HomeController homeController;
  final MechanicServiceController mechanicServiceController;
  final Function(dynamic) onAddService;

  const AllServices({
    super.key,
    required this.homeController,
    required this.onAddService,
    required this.mechanicServiceController,
  });

  @override
  State<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await widget.homeController.fetchMechanicService();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<MechanicServiceData> mechanicServiceData = widget.homeController.mechanicServiceModel.value.data ?? [];

      if (widget.homeController.isLoading2.value) {
        return Center(child: CustomPageLoading());
      }

      if (mechanicServiceData.isEmpty) {
        return Center(child: Text('Service not available now'));
      }

      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: mechanicServiceData.length,
        itemBuilder: (context, index) {
          final service = mechanicServiceData[index];
          final isAdded = widget.homeController.mechanicServiceModel.value.data?.contains(service);

          return MechanicServiceCard(
            service: service,
            isAdded: isAdded,
            addOnTap: () async{
             await widget.mechanicServiceController.addService(serviceId: service.sId,price: service.priceTEC?.text );

            },
          );
        },
      );
    });
  }
}