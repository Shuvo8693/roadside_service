class ApiConstants{
/// google maps

  static String googleBaseUrl="https://maps.googleapis.com/maps/api/place/autocomplete/json";
  static String estimatedTimeUrl="https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&";
   /// App Url
    static String baseUrl="https://radwan5000.sobhoy.com";
    static String  imageBaseUrl="http://10.0.80.205:9090";
    static String socketUrl="ws://10.0.80.205:9000";


///>>>>>>>>>>>>>>>>>>>>>>>>>>> User Auth>>>>>>>>>>>>>>>>>>>

static String registerUrl= '/api/v1/user/register';
static String verifyOtpUrl= '/api/v1/user/verify-otp';
static String verifyForgotOtpUrl(String userMail) =>  '/api/v1/user/verify-forget-otp?email=$userMail';
static String searchMechanicUrl(String service) =>  '/api/v1/mechanic/all?serviceName=$service';
static String mechanicDetailsUrl(String mechanicId) =>  '/api/v1/mechanic/$mechanicId';
static String mechanicAcceptOrderUrl(String orderId) =>  '/api/v1/order/accept/$orderId';
static String mechanicCancelOrderUrl(String orderId) =>  '/api/v1/order/cancel/$orderId';
static String mechanicMarkAsCompleteUrl(String orderId) =>  '/api/v1/order/markComplete/$orderId';
static String mechanicServiceWithPriceUrl(String mechanicId) =>  '/api/v1/mechanic/services/$mechanicId';
static String favouriteUrl(String mechanicId) =>  '/api/v1/favourite/toggle/$mechanicId';
static String orderStatusUrl(String status) =>  '/api/v1/order/$status';
static String toggleAvailabilityUrl(String mechanicId) =>  '/api/v1/mechanic/toggle-availability/$mechanicId';
static String allMechanicUrl({int? currentPage, int? limit}) =>  '/api/v1/mechanic/all?currentPage=$currentPage&limit=$limit';

static String emailSendUrl= '/api/v1/user/forget-password';
static String verifyEmailWithOtpUrl= '$baseUrl/auth/verify-email';
static String resendOtpUrl= '/api/v1/user/resend';
static String logInUrl= '/api/v1/user/login';
static String resetPasswordUrl= '/api/v1/user/reset-password';
static String changePasswordUrl= '/api/v1/user/change-password';
static String mechanicServiceUrl= '/api/v1/service/all';
static String userProfileUrl= '/api/v1/user/profile';
static String bookOrderUrl= '/api/v1/order';
static String addVehicleUrl= '/api/v1/vehicle';
static String allVehicleUrl= '/api/v1/vehicle/all';
static String bookedOrdersUrl= '/api/v1/order/user';
static String mechanicAvailabilityUrl= '/api/v1/mechanic/availability';
static String serviceAreaUrl= '/api/v1/mechanic/serviceRadius';
static String mechanicPaymentStatusUrl= '/api/v1/withdraw/mechanic';
static String walletOverviewUrl= '/api/v1/wallet';




}