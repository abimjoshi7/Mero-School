//
import 'package:flutter/foundation.dart';
import 'package:mero_school/presentation/constants/route.dart';

//
// const root_url = "https://demo.mero.school/";

const root_url = "https://mero.school/";

//
String getRootUrl() {
  // if(kReleaseMode){
  //     return "https://mero.school/";
  // }else{
  //     return "https://demo.mero.school/";
  // }
  return root_url;
}

String getFlavorTopic() {
  if (kDebugMode) {
    return "demo-user-4";
  }

  if (getRootUrl() == "https://mero.school/") {
    return "live-user";
  }

  return "demo-user-3";
}

// const base_url = "https://192.168.2.61/meroschool/Api/";
// const base_url = "https://mero.school/Api/";
String base_url = getRootUrl().toString() + "Api/";

// const base_url = "https://mero.school/Api/";
String base_url_V2 = getRootUrl().toString() + "Apiv2/";

String topic = getFlavorTopic();

String initialRoute = splash_page;
const system_settings = "system_settings";
const plan_category_settings = "categoryPlan";
const login = "login";
const my_courses = "my_courses";
const valid_courses = "validate_course_id";
const userdata = "userdata";
const my_wishlist = "my_wishlist";
const top_courses = "top_courses";
const all_plans = "all_plans";
const categories = "categories";
const filter_course = "filter_course";
const category_wise_course = "category_wise_course";
const course_details_by_id = "course_details_by_id";
const toggle_wishlist_items = "toggle_wishlist_items";
const update_password = "update_password";
const registration = "registration";
const otp_verification = "otpverification_v2";
const reset_password = "reset_passwod";
const reset = "reset";
const gmail_user_authentication = "gmail_user_authentication";
const my_transaction_history = "my_transaction_history";
const my_bank_history = "allBankPayment";
const update_userdata = "update_userdata";
const affiliatesRegistration = "affiliatesRegistration";
const upload_user_image = "upload_user_image";
const enrolled_to_free_course = "enrolledFreeCourse";
const smart_course_payment = "smart_course_payment";
const sections = "sections";
const save_course_progress = "save_course_progress";
const courses_by_search_string = "courses_by_search_string";
const subscription_type = "subscription_type";
const search_plan = "search_plan";
const reviews = "getReviews";
const addReview = "addReview";
const coursesExpire = "courses_expire";
const logoutEveryWhere = "logoutEvery";
const logoutSingle = "logout";
const bank_details = "getBankPayment";
const submit_deposited_slip = "addBankPayment";
const my_plan_post = "my_plan";
const validate_receipt = "appReceipt";

const planDetail = "getPlanDetail";
const coursesDetails = "courseDetail";
const entrance_config = "getEntranceConfig";
const relatedCoursePlan = "relatedCoursePlan";
const checkCertificateStr = "checkCertificate";

const courseV2 = "course";
const getLessons = "getLessons";
const googlePrice = "getGooglePrice";

//    @GET("apiv2/getPlanDetail")
//     Call<ResponseBody> getPlanDetails(
//             @Query("plan_id") int perpage
//     );
