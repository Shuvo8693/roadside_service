import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/account/controllers/account_controller.dart';
import 'package:roadside_assistance/app/modules/home/controllers/home_controller.dart' show HomeController;
import 'package:roadside_assistance/app/modules/home/widgets/service_category_card.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/controllers/mechanic_home_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/controllers/wallet_overview_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/model/wallet_overview_response.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/widgets/active_orederAndPayment_card.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/widgets/mechanic_custom_appbar.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/widgets/metrics_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_outlinebutton.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';
import 'package:roadside_assistance/app/modules/home/model/mechanic_service_model.dart';


class MechanicHomeView extends StatefulWidget {
  const MechanicHomeView({super.key});

  @override
  State<MechanicHomeView> createState() => _MechanicHomeViewState();
}

class _MechanicHomeViewState extends State<MechanicHomeView> {
  final HomeController _homeController = Get.put(HomeController());
  final AccountController accountController = Get.put(AccountController());
  final MechanicHomeController _mechanicHomeController = Get.put(MechanicHomeController());
  final WalletOverviewController _walletOverviewController = Get.put(WalletOverviewController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _homeController.fetchMechanicService();
      await accountController.fetchProfile();
      await _mechanicHomeController.fetchAvailability();
      await _walletOverviewController.fetchWalletOverview();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomMenu(0),
      appBar: MechanicAppBar(accountController: accountController, mechanicHomeController: _mechanicHomeController),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 650.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Choose Service Area button
                CustomOutlineButton(
                  height: 48.h,
                    onTap: (){
                    Get.toNamed(Routes.MAP_SERVICE_AREA);
                    },
                    text: 'Choose Service Area'),

                SizedBox(height: 16.h),
                /// Active Order and Payment row
                Obx((){
                  WalletData? walletData = _walletOverviewController.walletOverviewResponse.value.data;
                  return Row(
                    children: [
                      // Active Order
                      Expanded(
                        child: ActiveOrderAndPaymentCard(text: 'Active Order',
                          icon: Icons.assignment,
                          isShowStatus: true,
                          statusCount: walletData?.activeOrders??0,),
                      ),
                      // Payment
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ActiveOrderAndPaymentCard(
                          text: 'Payment', icon: Icons.payment,),
                      ),
                    ],
                  );
                }

                ),

                /// Complete order, earnings, withdraw
                SizedBox(height: 16.h),
                Obx((){
                  WalletData? walletData = _walletOverviewController.walletOverviewResponse.value.data;
                  return Row(
                    children: [
                      MetricsCard(
                        value: walletData?.totalCompletedOrder.toString() ??'0',
                        title: 'Complete Order',
                        backgroundColor: Colors.blue,
                        textColor: Colors.grey[800]!,
                      ),
                      SizedBox(width: 10.w),
                      MetricsCard(
                        value: '\$${walletData?.totalEarnings??0}',
                        title: 'Total Earnings',
                        backgroundColor: Colors.blue,
                        textColor: Colors.grey[800]!,
                      ),
                      SizedBox(width: 10.w),
                      MetricsCard(
                        value: '\$${walletData?.withdrawnAmount??0}',
                        title: 'Total Withdraw',
                        backgroundColor: Colors.blue,
                        textColor: Colors.grey[800]!,
                      ),
                    ],
                  );
                }

                ),

                /// Service Offered label
                SizedBox(height: 24.h),
                Text(
                  'Service Offered',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 16.h),

                /// Services grid
                SizedBox(height: 20.h),
                Obx(() {
                  List<MechanicServiceData>? mechanicServiceData = _homeController.mechanicServiceModel.value.data;
                  if(_homeController.isLoading2.value){
                    return CustomPageLoading();

                  } else if(mechanicServiceData?.isEmpty==true){
                    return Text('Mechanic service is now unavailable');
                  }
                  return ServiceCategories(mechanicServiceData: mechanicServiceData??[],);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

