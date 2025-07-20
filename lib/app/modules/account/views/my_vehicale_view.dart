import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/account/widgets/vehicale_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/app/modules/account/model/vehicle_model.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';

import '../controllers/my_vehicle_controller.dart';

class MyVehicleView extends StatefulWidget {
  const MyVehicleView({super.key});

  @override
  State<MyVehicleView> createState() => MyVehicleViewState();
}
class MyVehicleViewState extends State<MyVehicleView> {
  final MyVehicleController _myVehicleController = Get.put(MyVehicleController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
     await _myVehicleController.fetchVehicle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Vehicle'),
        //centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
             Get.toNamed(Routes.ADDVEHICLE);
            },
            child: Text(
              '+ Add Vehicle',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
      body: Obx((){
        List<Vehicle> vehicleLIst =_myVehicleController.vehicleModel.value.data??[];
        if(_myVehicleController.isLoading.value){
          return Center(child: CustomPageLoading());
        }
        if(vehicleLIst.isEmpty){
          return Center(child: Text('Vehicle looks empty'));
        }
        return  ListView.builder(
          //reverse: true,
          padding: EdgeInsets.all(10.r),
          itemCount: vehicleLIst.length,
          itemBuilder: (context, index) {
            final vehicleIndex = vehicleLIst[index];
            return VehicleCard(
              vehicleModel: vehicleIndex.model??'',
              vehicleBrand: vehicleIndex.brand??'',
              vehicleNumber: vehicleIndex.number??'',
              onDelete: () {
                _myVehicleController.deleteVehicle(vehicleId: vehicleIndex.id,callBack: (){
                  setState(() {
                    _myVehicleController.vehicleModel.value.data?.removeAt(index);
                  });
                });


              },
            );
          },
        );
      }

      ),
    );
  }
}

