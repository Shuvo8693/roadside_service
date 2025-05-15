import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/account/widgets/vehicale_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';

class MyVehicleView extends StatefulWidget {
  const MyVehicleView({super.key});

  @override
  State<MyVehicleView> createState() => MyVehicleViewState();
}
class MyVehicleViewState extends State<MyVehicleView> {
  List<Map<String, String>> vehicles = [
    {'model': 'Maruti', 'brand': 'Suzuki', 'number': '12-22-11'},
    {'model': 'Hyabusa', 'brand': 'Suzuki', 'number': '15642-2542-11'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Vehicle'),
        //centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
           final result = await Get.toNamed(Routes.ADDVEHICLE);
           vehicles.addAll(result);
           setState(() {});
           print(vehicles);
            },
            child: Text(
              '+ Add Vehicle',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        //reverse: true,
        padding: EdgeInsets.all(10.r),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
         final vehicleIndex = vehicles[index];
          return VehicleCard(
            vehicleModel: vehicleIndex['model']??'',
            vehicleBrand: vehicleIndex['brand']??'',
            vehicleNumber: vehicleIndex['number']??'',
            onDelete: () {
              setState(() {
                vehicles.removeAt(index);
              });
            },
          );
        },
      ),
    );
  }
}

