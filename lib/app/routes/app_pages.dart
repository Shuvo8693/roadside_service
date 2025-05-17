import 'dart:collection';

import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/about_screen.dart';
import '../modules/account/views/account_view.dart';
import '../modules/account/views/add_vehicle_view.dart';
import '../modules/account/views/faq_view.dart';
import '../modules/account/views/favourite_view.dart';
import '../modules/account/views/my_info_view.dart';
import '../modules/account/views/my_vehicale_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/check_out/bindings/check_out_binding.dart';
import '../modules/check_out/views/check_out_view.dart';
import '../modules/check_out/views/checkout_signup_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/mechanic_home/bindings/mechanic_home_binding.dart';
import '../modules/mechanic_home/views/map_service_area_view.dart';
import '../modules/mechanic_home/views/mechanic_home_view.dart';
import '../modules/mechanic_order/bindings/mechanic_order_binding.dart';
import '../modules/mechanic_order/views/mechanic_order_view.dart';
import '../modules/mechanic_user_side/bindings/mechanic_binding.dart';
import '../modules/mechanic_user_side/views/mechanic_details_view.dart';
import '../modules/mechanic_user_side/views/mechanic_view.dart';
import '../modules/mechanic_user_side/views/rating_and_review_view.dart';
import '../modules/message_inbox/bindings/message_inbox_binding.dart';
import '../modules/message_inbox/views/message_inbox_view.dart';
import '../modules/my_booking/bindings/my_booking_binding.dart';
import '../modules/my_booking/views/my_booking_view.dart';
import '../modules/my_booking/views/order_tracking_view.dart';
import '../modules/my_booking/views/previous_booking.dart';
import '../modules/my_location_selection/bindings/my_location_selection_binding.dart';
import '../modules/my_location_selection/views/map_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding1_view.dart';
import '../modules/onboarding/views/onboarding2_view.dart';
import '../modules/onboarding/views/onboarding3_view.dart';
import '../modules/onboarding/views/role_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const Onboarding1View(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ONBOARDING2,
      page: () => const Onboarding2View(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ONBOARDING3,
      page: () => const Onboarding3View(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ROLE,
      page: () => const RoleView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
        name: _Paths.SIGN_IN,
        page: () => const SignInView(),
        binding: SignInBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: _Paths.FORGOT_PASSWORD,
        page: () => const ForgotPasswordView(),
        binding: ForgotPasswordBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: _Paths.CHANGE_PASSWORD,
        page: () => const ChangePasswordView(),
        binding: ChangePasswordBinding(),
        transition: Transition.cupertino),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE,
      page: () => const MyBookingView(),
      binding: MyBookingBinding(),
    ),
    GetPage(
      name: _Paths.ORDERTRACKING,
      page: () => const OrderTrackingView(),
      binding: MyBookingBinding(),
    ),
    GetPage(
      name: _Paths.MECHANIC,
      page: () => MechanicView(),
      binding: MechanicBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.MYINFO,
      page: () => const MyInfo(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.MAP,
      page: () => MapLocationView(),
      binding: MyLocationSelectionBinding(),
    ),
    GetPage(
      name: _Paths.MECHANICDETAILS,
      page: () => MechanicDetailsView(),
      binding: MechanicBinding(),
    ),
    GetPage(
      name: _Paths.RATINGANDREVIEW,
      page: () => RatingAndReviewView(),
      binding: MechanicBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_OUT,
      page: () => const CheckOutView(),
      binding: CheckOutBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_OUT_SIGNUP,
      page: () => CheckoutSignupView(),
      binding: CheckOutBinding(),
    ),
    GetPage(
      name: _Paths.PREVIOUSBOOKING,
      page: () => PreviousBooking(),
      binding: MyBookingBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => FAQView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.FAVOURITE,
      page: () => FavouriteView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.ABOUTUS,
      page: () => AboutScreen(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.MYVEHECLE,
      page: () => MyVehicleView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.ADDVEHICLE,
      page: () => AddVehicleView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGEINBOX,
      page: () => MessageInboxView(),
      binding: MessageInboxBinding(),
    ),
    GetPage(
      name: _Paths.MECHANIC_HOME,
      page: () => const MechanicHomeView(),
      binding: MechanicHomeBinding(),
    ),
    GetPage(
      name: _Paths.MAP_SERVICE_AREA,
      page: () => const MapServiceAreaView(),
      binding: MechanicHomeBinding(),
    ),
    GetPage(
      name: _Paths.MECHANIC_ORDER,
      page: () => const MechanicOrderView(),
      binding: MechanicOrderBinding(),
    ),
  ];
}
