import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/home/model/mechanic_service_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_model.dart';
import 'package:roadside_assistance/app/modules/home/controllers/home_controller.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_providere_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';
import 'package:roadside_assistance/common/widgets/custom_search_field.dart';

import '../controllers/mechanic_controller.dart';


class MechanicView extends StatefulWidget {
   const MechanicView({super.key});

  @override
  State<MechanicView> createState() => _MechanicViewState();
}

class _MechanicViewState extends State<MechanicView> {
 final TextEditingController searchCtrl = TextEditingController();

   final MechanicController _mechanicController = Get.put(MechanicController());

   final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(2,chooseServiceOrOrder: 'Mechanic',),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('MechanicView'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(8.0.sp),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            CustomSearchField(
              searchCtrl: searchCtrl,
              iconOnTap: () {},
              onChanged: (value) async {
                if(value!.isNotEmpty){
                  await _homeController.fetchMechanicQuery(queryService: value);
                }else{
                  setState(() {
                    _homeController.mechanicModel.value.mechanicData?.data?.clear();
                  });
                }
              },
            ),

            SizedBox(height: 20.h),
            Obx(() {
              List<MechanicAttributes> mechanicAttributes = _homeController.mechanicModel.value.mechanicData?.data??[];
              if(_homeController.isLoading.value){
                return CustomPageLoading();

              } else if(mechanicAttributes.isEmpty==true){
                return Text('Mechanic service is now unavailable');
              }
              return ListView.builder(
                itemCount: mechanicAttributes.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final mechanicAttributesIndex = mechanicAttributes[index];
                  return ServiceProviderCard(
                    name: mechanicAttributesIndex.mechanicName??'',
                    title: 'Mechanic',
                    distance: mechanicAttributesIndex.distance??'',
                    rating: mechanicAttributesIndex.rating??0,
                    duration: mechanicAttributesIndex.eta??'',
                    imageUrl: mechanicAttributesIndex.mechanicImage??'',
                    isFavourite: mechanicAttributesIndex.isFavourite??false,
                    onTap: () {
                      Get.toNamed(Routes.MECHANICDETAILS,arguments: {'mechanicId': mechanicAttributesIndex.mechanicId });
                    },
                    favouriteTap: () {
                      int? dataIndex  = _homeController.mechanicModel.value.mechanicData?.data?.indexWhere((value)=>value.mechanicId==mechanicAttributesIndex.mechanicId);
                      if(dataIndex != -1){
                        final attributes = _homeController.mechanicModel.value.mechanicData?.data![dataIndex!];
                        attributes?.isFavourite = !(attributes.isFavourite??false);
                        _homeController.mechanicModel.refresh();
                        setState(() {});

                        _mechanicController.toggleFavourite( mechanicAttributesIndex.mechanicId??'',favCallBack: (){

                        },onError: (){
                          attributes?.isFavourite = !(attributes.isFavourite??false);
                          _homeController.mechanicModel.refresh();
                          setState(() {});
                        });
                      }

                    },
                  );
                },
              );
            }),
         ],
        ),
      ),
    );
  }
}
