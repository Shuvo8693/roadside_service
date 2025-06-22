import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/check_out/controllers/check_out_controller.dart';
import 'package:roadside_assistance/app/modules/check_out/widgets/checkout_service_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';


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
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _checkOutController.fetchMechanicServiceWithPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               //// Selected Towing Service Card
              Text('Selected service :'),
              ...List.generate(2, (index){
              final serviceCategoryItem = AppConstants.serviceCategories[index];
                return CheckOutServiceCard(
                  serviceName: serviceCategoryItem['category'],
                  price: '\$100',
                  svgAssetPath: serviceCategoryItem['icon'],
                  iconButton: () { },
                );
              }),

               /// Add More Service Button
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add More Service',style: GoogleFontStyles.h4(),),
                      InkWell(
                        onTap: (){
                          isAddMoreService =! isAddMoreService;
                          setState(() {});
                        },
                          child: Icon(Icons.add_circle, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),

               //// List of Service
               if(isAddMoreService)
                 Wrap(
                   children: [
                     Text('Choose service :'),
                     SizedBox(
                       height: 250.h,
                       child: ListView.builder(
                         itemBuilder: (context,index){
                           final serviceCategoryItem = AppConstants.serviceCategories[index];
                           return CheckOutServiceCard(
                             serviceName: serviceCategoryItem['category'],
                             price: '\$100',
                             svgAssetPath: serviceCategoryItem['icon'],
                             iconButton: () { },
                             icon: Icons.add_circle,
                             iconColor: AppColors.primaryColor,
                           );
                         },
                         itemCount: AppConstants.serviceCategories.length ,),
                     ),
                   ],
                 ),


               /// Breakdown of Charges
              verticalSpacing(20.h),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  children: [
                    ...List.generate(AppConstants.serviceCategories.length, (index){
                      final serviceCategoryItem = AppConstants.serviceCategories[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(serviceCategoryItem['category']),
                            Text('\$100'),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('App Service'),
                        Text('\$10'),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$110', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              verticalSpacing(100.h)
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: CustomButton(
            onTap: (){
          Get.toNamed(Routes.CHECK_OUT_SIGNUP);
        }, text: 'Next'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
