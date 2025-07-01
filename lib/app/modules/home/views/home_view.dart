import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/account/controllers/account_controller.dart';
import 'package:roadside_assistance/app/modules/home/controllers/home_controller.dart';
import 'package:roadside_assistance/app/modules/home/model/mechanic_service_model.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_card.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_providere_card.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/controllers/mechanic_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_model.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_appBar_title.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';
import 'package:roadside_assistance/common/widgets/custom_search_field.dart';
import 'package:roadside_assistance/common/widgets/custom_textbutton_with_icon.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
final HomeController _homeController = Get.put(HomeController());
final MechanicController _mechanicController =Get.put(MechanicController());
final AccountController _accountController= Get.put(AccountController());

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _homeController.fetchMechanicService();
      await _accountController.fetchProfile();
      await _mechanicController.fetchMechanic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(0),
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarTitle(
        notificationOnTap: () {
          Get.toNamed(Routes.NOTIFICATION);
        },
        notificationCount: 5,
        imageUrl: AppConstants.demoPersonImage,
        accountController: _accountController,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// My location
              CustomTextButtonWithIcon(
                onTap: () {
                  Get.toNamed(Routes.MAP);
                },
                text: 'New York, Usa',
                icon: Icon(Icons.location_on, color: Colors.grey, size: 23.h),
                width: 85.w,
                height: 30.h,
                textStyle: GoogleFontStyles.h3(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              /// Mechanic search
              SizedBox(height: 10.h),
              CustomSearchField(
                searchCtrl: _homeController.searchCtrl,
                iconOnTap: () {},
                onChanged: (value) async{
                 await _homeController.fetchMechanicQuery(queryService: value);
                },
              ),
             /// Mechanic Search result
              mechanicDataCard(_homeController),
              // Obx(() {
              //   List<MechanicAttributes> mechanicAttributes = _homeController.mechanicModel.value.data?.data??[];
              //   if(_mechanicController.isLoading.value){
              //     return CustomPageLoading();
              //   } else if(mechanicAttributes.isEmpty){
              //     return Text('');
              //   }
              //   return ListView.builder(
              //     itemCount: (mechanicAttributes.length > 10 ? 10 : mechanicAttributes.length),
              //     shrinkWrap: true,
              //     itemBuilder: (BuildContext context, int index) {
              //       final mechanicAttributesIndex = mechanicAttributes[index];
              //       return ServiceProviderCard(
              //         name: mechanicAttributesIndex.mechanicName??'',
              //         title: 'Mechanic',
              //         distance: mechanicAttributesIndex.distance??'',
              //         rating: mechanicAttributesIndex.rating??0,
              //         duration: mechanicAttributesIndex.eta??'',
              //         imageUrl: mechanicAttributesIndex.mechanicImage??'',
              //         onTap: () {
              //           Get.toNamed(Routes.MECHANICDETAILS,arguments: {'mechanicId': mechanicAttributesIndex.mechanicId });
              //         },
              //       );
              //     },
              //   );
              // }),

              /// Service
              SizedBox(height: 20.h),
              Obx(() {
                 List<MechanicServiceData>? mechanicServiceData = _homeController.mechanicServiceModel.value.data;
                 if(_homeController.isLoading2.value){
                   return  CustomPageLoading();

                 } else if(mechanicServiceData?.isEmpty==true){
                   return Text('Mechanic service is now unavailable');
                 }
                return ServiceCategories(mechanicServiceData: mechanicServiceData??[],);
              }),
              /// Nearest service provider
              SizedBox(height: 20.h),
              Text(
                'Nearest Service Provider',
                style: GoogleFontStyles.h3(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10.h),
              mechanicDataCard(_mechanicController),
              // Obx(() {
              //   List<MechanicAttributes> mechanicAttributes = _mechanicController.mechanicModel.value.data?.data??[];
              //   if(_mechanicController.isLoading.value){
              //     return CustomPageLoading();
              //   } else if(mechanicAttributes.isEmpty){
              //     return Text('Mechanics unavailable near your location');
              //   }
              //   return ListView.builder(
              //     itemCount: (mechanicAttributes.length > 10 ? 10 : mechanicAttributes.length),
              //     shrinkWrap: true,
              //     itemBuilder: (BuildContext context, int index) {
              //       final mechanicAttributesIndex = mechanicAttributes[index];
              //       return ServiceProviderCard(
              //         name: mechanicAttributesIndex.mechanicName??'',
              //         title: 'Mechanic',
              //         distance: mechanicAttributesIndex.distance??'',
              //         rating: mechanicAttributesIndex.rating??0,
              //         duration: mechanicAttributesIndex.eta??'',
              //         imageUrl: mechanicAttributesIndex.mechanicImage??'',
              //         onTap: () {
              //           Get.toNamed(Routes.MECHANICDETAILS,arguments: {'mechanicId': mechanicAttributesIndex.mechanicId });
              //         },
              //       );
              //     },
              //   );
              // }),
            ],
          ),
        ),
      ),
    );
  }

 Widget mechanicDataCard<T>(T controller){
    return Obx(() {
      // List<MechanicAttributes> mechanicAttributes = _mechanicController.mechanicModel.value.data?.data??[];
      List<MechanicAttributes> mechanicAttributes =[];
      bool isLoading= false;
      if(T == MechanicController){
        final mechanicController = controller as MechanicController;
       mechanicAttributes  = mechanicController.mechanicModel.value.data?.data??[];
        isLoading = mechanicController.isLoading.value;
      } else if (T == HomeController){
        final mechanicController = controller as HomeController;
        mechanicAttributes  = mechanicController.mechanicModel.value.data?.data??[];
        isLoading = mechanicController.isLoading.value;
      }

      if(isLoading){
        return CustomPageLoading();
      } else if(mechanicAttributes.isEmpty){
        return Text(T == HomeController? '':'Mechanics unavailable near your location');
      }
      return ListView.builder(
        itemCount: (mechanicAttributes.length > 10 ? 10 : mechanicAttributes.length),
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
            onTap: () {
              Get.toNamed(Routes.MECHANICDETAILS,arguments: {'mechanicId': mechanicAttributesIndex.mechanicId });
            },
            favouriteTap: () async {
              String? mechanicId= mechanicAttributesIndex.mechanicId;
              if(mechanicId != null && mechanicId.isNotEmpty){
              await _mechanicController.toggleFavourite( mechanicId,favCallBack: (){
                if(T == MechanicController){
                  int? dataIndex  = _mechanicController.mechanicModel.value.data?.data?.indexWhere((value)=>value.mechanicId==mechanicId);
                  if(dataIndex != -1){
                    final attributes = _mechanicController.mechanicModel.value.data?.data![dataIndex!];
                    attributes?.isFavourite =! (attributes.isFavourite??false);
                    print(attributes?.isFavourite);
                    _mechanicController.mechanicModel.refresh();
                    setState(() {});
                  }

                }else if(T == HomeController){
                  int? dataIndex  = _homeController.mechanicModel.value.data?.data?.indexWhere((value)=>value.mechanicId==mechanicId);
                  if(dataIndex != -1){
                    final attributes = _homeController.mechanicModel.value.data?.data![dataIndex!];
                    attributes?.isFavourite =! (attributes.isFavourite??false);
                    print(attributes?.isFavourite);
                    _homeController.mechanicModel.refresh();
                    setState(() {});
                  }
                }
              });
              }
          },
            isFavourite: mechanicAttributesIndex.isFavourite??false,
          );
        },
      );
    });
  }
}
