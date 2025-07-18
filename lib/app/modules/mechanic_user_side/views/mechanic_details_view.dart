import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/check_out/controllers/check_out_controller.dart';
import 'package:roadside_assistance/app/modules/check_out/model/service_rate_model.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/controllers/mechanic_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_details_model.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';
import 'package:roadside_assistance/common/widgets/see_more_text.dart';


class MechanicDetailsView extends StatefulWidget {
  const MechanicDetailsView({super.key});

  @override
  State<MechanicDetailsView> createState() => _MechanicDetailsViewState();
}

class _MechanicDetailsViewState extends State<MechanicDetailsView> {
  final MechanicController _mechanicController = Get.put(MechanicController());
  final CheckOutController _checkOutController = Get.put(CheckOutController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _mechanicController.fetchMechanicDetails();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mechanic Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Obx(() {
          MechanicData?  mechanicData = _mechanicController.mechanicDetailsModel.value.data ?? MechanicData();
          if(mechanicData.mechanic == null ){
            return Text('Mechanic details looks empty');
          } else if(_mechanicController.isLoading2.value){
            return Center( child: CustomPageLoading());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mechanic Image and Name Section
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0.r),
                    child: CustomNetworkImage(
                      imageUrl:  mechanicData.mechanic?.image??'',
                      // Replace with your image path
                      width: 110.h,
                      height: 110.h,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Mechanic name ------>
                        Text(
                          mechanicData.mechanic?.name??'',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //Const Car Mechanic ---->
                        SizedBox(height: 4.h),
                        Text(
                          'Car Mechanic',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.RATINGANDREVIEW);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.orangeAccent, size: 22),
                              // Rating
                              SizedBox(width: 4.h),
                              Text(
                                '${mechanicData.mechanic?.rating}/5',
                                style: GoogleFontStyles.h4(
                                    color: AppColors.primaryColor),
                              ),
                              Icon(Icons.keyboard_arrow_right_outlined,
                                  color: AppColors.primaryColor, size: 20),
                            ],
                          ),
                        ),
                        // Experience ---->
                        SizedBox(height: 4.h),
                        Text('Experience: ${mechanicData.mechanic?.experience} Years',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Mechanic Description -------------<<<
              SeeMoreText(text: mechanicData.mechanic?.description??'',characterLimit: 150,style: TextStyle(fontSize: 13, color: Colors.grey) ,),

              SizedBox(height: 20.h),

              // Service Section Title -----------<<
              Text(
                'Service',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),

              // Service Options in Grid --------<<
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    ...mechanicData.serviceWithRate!.services!.asMap().map((index, category) {
                     bool isSelected = _checkOutController.serviceRateList.any((service)=>service.serviceName== category.service?.name);
                      return MapEntry(index,
                        GestureDetector(
                          onTap: () {
                            print(category.sId);
                          },
                          child: ServiceCategoryContainer(
                            category: category.service?.name??'',
                            icon: category.service?.image??'',
                            isActiveBooking: true,
                            price: '\$${category.price}',
                            bookNowOnTap: () {
                              if(!isSelected){
                                _checkOutController.serviceRateList.add(
                                  ServiceRate(
                                    serviceImage: category.service?.image??'',
                                    price: category.price,
                                    serviceName: category.service?.name??'',
                                    serviceId: category.service?.sId
                                  ),
                                );
                              }else{

                              }
                              Get.toNamed(Routes.CHECK_OUT,arguments: {'mechanicId':mechanicData.mechanic?.sId});
                            },
                          ),
                        ),
                      );
                    }).values,
                  ],
                ),
              ),
            ],
          );
        }

        ),
      ),
    );
  }
}

