import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/check_out/controllers/check_out_controller.dart';
import 'package:roadside_assistance/app/modules/check_out/model/mechanic_service_price_model.dart';
import 'package:roadside_assistance/app/modules/check_out/widgets/checkout_service_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

import '../model/service_rate_model.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  final CheckOutController _checkOutController = Get.put(CheckOutController());
  bool isAddMoreService = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await _checkOutController.fetchMechanicServiceWithPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //// Selected Towing Service Card
              Text('Selected service :'),
              Obx(() {
                final serviceRateList = _checkOutController.serviceRateList;
                return Column(
                  children: [
                    ...List.generate(serviceRateList.length, (index) {
                      final serviceCategoryItem = serviceRateList[index];
                      return CheckOutServiceCard(
                        serviceName: serviceCategoryItem.serviceName ?? '',
                        price: '\$${serviceCategoryItem.price}',
                        svgPath: serviceCategoryItem.serviceImage,
                        iconButton: () {
                          _checkOutController.serviceRateList.removeAt(index);
                        },
                      );
                    }),
                  ],
                );
              }),

              /// Add More Service Button
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add More Service', style: GoogleFontStyles.h4()),
                      InkWell(
                        onTap: () {
                          isAddMoreService = !isAddMoreService;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.add_circle,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //// List of Service
              if (isAddMoreService)
                Wrap(
                  children: [
                    Text('Choose service :'),
                    Obx(() {
                      List<ServiceWithPrice>? serviceWithPriceData =
                          _checkOutController.mechanicServicePriceModel.value.data?.servicesWithPrice;

                      if (_checkOutController.isLoading.value) {
                        return Center(child: CustomPageLoading());
                      } else if (serviceWithPriceData!.isEmpty) {
                        return Text('No service available here');
                      }

                      return SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final serviceCategoryItem = serviceWithPriceData[index];
                           String serviceName = serviceCategoryItem.service?.name ?? '';
                            return Obx((){
                              bool isSelected = _checkOutController.serviceRateList.any((serviceDetails) => serviceDetails.serviceName == serviceName);
                              return  CheckOutServiceCard(
                                serviceName: serviceName,
                                price: '\$${serviceCategoryItem.price}',
                                svgPath: serviceCategoryItem.service?.image,
                                iconButton: () {
                                  if(!isSelected){
                                    _checkOutController.serviceRateList.add(
                                      ServiceRate(
                                        serviceImage: serviceCategoryItem.service?.image,
                                        price: serviceCategoryItem.price,
                                        serviceName: serviceName,
                                        serviceId: serviceCategoryItem.id
                                      ),
                                    );
                                  }else{
                                    //_checkOutController.mechanicServicePriceModel.value.data?.services?.removeWhere((item)=> _checkOutController.serviceRateList.any((serviceDetails) => serviceDetails.serviceName == item.service?.name));
                                  }
                                },
                                icon: isSelected ? Icons.check_circle_rounded : Icons.add_circle,
                                iconColor: AppColors.primaryColor,
                              );
                            }

                            );
                          },
                          itemCount: serviceWithPriceData.length,
                        ),
                      );
                    }),
                  ],
                ),

              /// Breakdown of Charges
              verticalSpacing(20.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Obx((){
                final serviceRateList = _checkOutController.serviceRateList;
                double servicePrice = 0.0;
                double serviceCharge = 0.0;
                for(final service in serviceRateList){
                  servicePrice += service.price ?? 0.0;
                }
                  serviceCharge = servicePrice * 0.1;
                  return Column(
                    children: [
                      ...List.generate(serviceRateList.length, (index) {
                        final serviceCategoryItem = serviceRateList[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //service name
                              Text(serviceCategoryItem.serviceName.toString()),
                              // price
                              Text('\$${serviceCategoryItem.price}'),
                            ],
                          ),
                        );
                      }),

                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('App Service (10%)'), Text('\$$serviceCharge')],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('\$${servicePrice + serviceCharge}', style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  );
                 }

                ),
              ),
              verticalSpacing(100.h),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: CustomButton(
          onTap: () {
            String mechanicId = Get.arguments['mechanicId']??'';
            print(mechanicId);
            if(mechanicId.isNotEmpty ){
              Get.toNamed(Routes.CHECK_OUT_SIGNUP,arguments: {'mechanicId': mechanicId });
            }
          },
          text: 'Next',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
