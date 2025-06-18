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
static String searchMechanicUrl(String service) =>  '/api/v1/mechanic/sorted?serviceName=$service';

static String emailSendUrl= '/api/v1/user/forget-password';
static String verifyEmailWithOtpUrl= '$baseUrl/auth/verify-email';
static String resendOtpUrl= '/api/v1/user/resend';
static String logInUrl= '/api/v1/user/login';
static String resetPasswordUrl= '/api/v1/user/reset-password';
static String changePasswordUrl= '/api/v1/user/change-password';
static String createTournamentUrl= '$baseUrl/tournament/create';
static String createSponsorTournamentUrl= '$baseUrl/sponser-tournament';
static String lookingToPlayCreationUrl= '$baseUrl/looking-toplay';
static String requestToPlaylistUrl(String type,int page,int limit) => '$baseUrl/request-to-play?typename=big&page=$page&limit=$limit';
static String tournamentDetailsUrl(String type,String tournamentId) => '$baseUrl/entered/details?id=$tournamentId&type=$type';
static String tournamentPlayerUrl(String type,String tournamentId) => '$baseUrl/teeSheet/showTournamentById?id=$tournamentId&typeName=$type';
static String showAllPlayerUrl(String type,String tournamentId) => '$baseUrl/chaleng/showAllplayer?type=$type&id=$tournamentId';
static String showAllMatchesUrl(String type,String tournamentId) => '$baseUrl/chaleng?id=$tournamentId&type=$type';
static String tournamentCompletionStatusUrl(String type,String tournamentId) => '$baseUrl/small-tournament/make-tournament-complete?id=$tournamentId&type=$type';



}