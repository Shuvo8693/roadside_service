import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/home/controllers/home_controller.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_card.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_providere_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_appBar_title.dart';
import 'package:roadside_assistance/common/widgets/custom_search_field.dart';
import 'package:roadside_assistance/common/widgets/custom_textbutton_with_icon.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
final HomeController _homeController = Get.put(HomeController());

@override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 10.h),
              CustomSearchField(
                searchCtrl: _homeController.searchCtrl,
                iconOnTap: () {},
                onChanged: (value) async{
                 await _homeController.fetchMechanic(queryService: value);
                },
              ),
              SizedBox(height: 20.h),
              ServiceCategories(),
              SizedBox(height: 20.h),
              Text(
                'Nearest Service Provider',
                style: GoogleFontStyles.h3(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10.h),
              ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ServiceProviderCard(
                    name: 'Shuvo',
                    title: 'Mechanic',
                    distance: '1000 km',
                    rating: 4.5,
                    time: '30 min',
                    imageUrl: AppConstants.mechanicImage,
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
