class BaseUrl {

  // static String url = "https://hubcare-node.codemeg.com/api/";
  // static String imageUrl = "https://hubcare-node.codemeg.com";
  //
  // static String url = "http://192.168.1.10:3017/api/";
  //  static String imageUrl = "http://192.168.1.10:3017";

  static String url = "http://72.61.176.150:3000/api/";
   static String imageUrl = "http://72.61.176.150:3000";

 static String googleUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

 /// --------------------------- Post -------------------------- ///

 static var signUp = "${url}signup";
 static var login = "${url}login";
 static var socialLogin = "${url}social-login";
 static var verifyOtp = "${url}verify-otp";
 static var sendOtp = "${url}send-otp";
 static var resendOtp = "${url}auth/reset-password";
 static var updateProfile = "${url}update-profile";
 static var forgotPassword = "${url}auth/forget-password";
 static var resetPassword = "${url}auth/reset-password";
 static var changePassword = "${url}auth/change-password";
 static var userLocation = "${url}user_location/add-location";

 static var messagesSend = "${url}send";
 static var addBooking = "${url}booking_service/add-booking/";
  static String cancelBooking = "${url}booking_service/cancel-booking";
  static String submitReview = "${url}review/submitReview/";
  static String helpSupport = "${url}help_support/create";
  static String addToWallet = "${url}wallet/add-to-wallet";
  static String bookingStartEnd = "${url}booking_service/booking-action/";


 /// --------------------------- Get -------------------------- ///


 static String getProfile = "${url}get-user-profile?";
 static String getCategories = "${url}category/list";
 static String getSubCategories = "${url}sub_category/category";
 static String getSubCategoriesToCategory = "${url}subCategory_service/category";
 static String getSubCategoriesToCategoryDetail = "${url}subCategory_service/service";
 static String getOurBestServices = "${url}subCategory_service/our-best-services";
 static String getProviderDetail = "${url}subCategory_service/services/provider";
 static String getSearchFilter = "${url}subCategory_service/services";
 static String getServicesUsed = "${url}subCategory_service/services-used";
 static String getServicesRecommended = "${url}subCategory_service/recommended-services";
 static String getReview = "${url}review/review";
 static String getSliderImage = "${url}slider/slider?";
 static String getLocation = "${url}user_location/get-location";
 static String getCheckCoupanCode = "${url}promo-offer/checkCouponCode?";
 static String getPrivacyPolicy = "${url}privacy_policy/policy";
 static String getProviders = "${url}sub_category/get-Providers/";
 static String allProviderList = "${url}category/all-provider/";

 static String getMessagesUserList  = "${url}chat?";
 static String getMessages  = "${url}getmessages/";
 static String getNotification = "${url}notification/all-notifications?";
 static String getOffer = "${url}promo-offer/offers";
 static String getBooking = "${url}booking_service/bookings?";
 static String getBookingStatus = "${url}booking_service/booking-status";
 static String getBookingDetails = "${url}booking_service/booking-details";
 static String getMyWallet = "${url}wallet/my-wallet";
 static String getTransactions = "${url}wallet/latest-transactions";


 ///------------------------Put------------------------ /////




}