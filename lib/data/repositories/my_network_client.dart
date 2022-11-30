import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mero_school/data/models/request/courses_request.dart';
import 'package:mero_school/data/models/request/edit_profile_request.dart';
import 'package:mero_school/data/models/request/enrolled_to_free_course_request.dart';
import 'package:mero_school/data/models/request/in_app_payment_request.dart';
import 'package:mero_school/data/models/request/in_app_receipt_validate_request.dart';
import 'package:mero_school/data/models/request/login_request.dart';
import 'package:mero_school/data/models/request/my_transaction_history_request.dart';
import 'package:mero_school/data/models/request/otp_verification_request.dart';
import 'package:mero_school/data/models/request/registration_request.dart';
import 'package:mero_school/data/models/request/reset_password_request.dart';
import 'package:mero_school/data/models/request/reset_request.dart';
import 'package:mero_school/data/models/request/review_added_request.dart';
import 'package:mero_school/data/models/request/search_plan_request.dart';
import 'package:mero_school/data/models/request/smart_course_payment_request.dart';
import 'package:mero_school/data/models/request/smart_plan_payment.dart';
import 'package:mero_school/data/models/request/social_login_request.dart';
import 'package:mero_school/data/models/request/update_password_request.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/data/models/response/bank_submit_response.dart';
import 'package:mero_school/data/models/response/categories_response.dart';
import 'package:mero_school/data/models/response/certificate_status_response.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/courses_response.dart';
import 'package:mero_school/data/models/response/curriculum_data_res_model.dart';
import 'package:mero_school/data/models/response/edit_profile_response.dart';
import 'package:mero_school/data/models/response/enrolled_to_free_course_response.dart';
import 'package:mero_school/data/models/response/entrance_config.dart';
import 'package:mero_school/data/models/response/filter_course_response.dart';
import 'package:mero_school/data/models/response/google_price_res_model.dart';
import 'package:mero_school/data/models/response/in_app_response.dart';
import 'package:mero_school/data/models/response/in_app_validate_response.dart';
import 'package:mero_school/data/models/response/login_response.dart';
import 'package:mero_school/data/models/response/logout_response.dart';
import 'package:mero_school/data/models/response/my_bank_history_response.dart';
import 'package:mero_school/data/models/response/my_course_response.dart';
import 'package:mero_school/data/models/response/my_transaction_history_response.dart';
import 'package:mero_school/data/models/response/my_valid_course_response.dart';
import 'package:mero_school/data/models/response/my_wishlist_response.dart';
import 'package:mero_school/data/models/response/plan_category_response.dart';
import 'package:mero_school/data/models/response/registration_response.dart';
import 'package:mero_school/data/models/response/related_plan_response.dart';
import 'package:mero_school/data/models/response/remove_wish_list_response.dart';
import 'package:mero_school/data/models/response/reset_passwod_response.dart';
import 'package:mero_school/data/models/response/reset_response.dart';
import 'package:mero_school/data/models/response/review_response.dart';
import 'package:mero_school/data/models/response/save_course_progress_response.dart';
import 'package:mero_school/data/models/response/section_data_res_model.dart';
import 'package:mero_school/data/models/response/section_response.dart';
import 'package:mero_school/data/models/response/smart_course_payment_response.dart';
import 'package:mero_school/data/models/response/social_login_response.dart';
import 'package:mero_school/data/models/response/subscription_type_response.dart';
import 'package:mero_school/data/models/response/system_settings_response.dart';
import 'package:mero_school/data/models/response/top_course_response.dart';
import 'package:mero_school/data/models/response/update_password_response.dart';
import 'package:mero_school/data/models/response/user_data_response.dart';
import 'package:mero_school/data/models/response/user_image_response.dart';
import 'package:mero_school/data/models/response/video_response.dart';
import 'package:mero_school/networking/ApiProvider.dart';
import 'package:mero_school/networking/ApiService.dart';
import 'package:mero_school/presentation/constants/api_end_point.dart';
import 'package:mero_school/presentation/constants/strings.dart' as Strings;
import 'package:mero_school/presentation/pages/bank_transfer/bank_detail_response.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../models/request/affiliate_request.dart';
import '../models/response/affiliate_response.dart';

class MyNetworkClient {
  ApiProvider _provider = ApiProvider();
  // ApiProviderV2 _provider2 = ApiProviderV2();
  ApiService _service = ApiService();

  Future<SystemSettingsResponse> fetchSystemSettings() async {
    final response = await _provider.get(system_settings);
    // print(response.toString());
    return SystemSettingsResponse.fromJson(response);
  }

  Future<PlanCategoryResponse> fetchPlanSettings() async {
    final response =
        await _provider.getWithParamsV2(plan_category_settings, "");
    return PlanCategoryResponse.fromJson(response);
  }

  // Future<AffiliateResponse> fetchAffiliateResponse(
  //     AffiliateRequest affiliateRequest) async {
  //   var json = jsonEncode(affiliateRequest.toJson());
  //   final response = await _provider.post(registration, json);
  //   return AffiliateResponse.fromJson(response);
  // }

  Future<LoginResponse> fetchLoginResponse(LoginRequest loginRequest) async {
    var json = jsonEncode(loginRequest.toJson());
    final response = await _provider.post(login, json);

    // print("===api: "+ response.toString());

    return LoginResponse.fromJson(response);
  }

  Future<LoginResponse> fetchOTPVerification(
      OtpVerificationRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.postV2("$otp_verification", json);
    return LoginResponse.fromJson(response);
  }

  Future<MyCourseResponse> fetchMyCourses(String authToken) async {
    final response =
        await _provider.getWithParams(my_courses, "auth_token=" + authToken);
    return MyCourseResponse.fromJson(response);
  }

  Future<MyValidCourseResponse> fetchValidCourse(String authToken) async {
    GeneralTokenRequest request = GeneralTokenRequest(authToken: authToken);
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(valid_courses, json);
    return MyValidCourseResponse.fromJson(response);
  }

  Future<UserDataResponse> fetchUserData(String authToken) async {
    final response =
        await _provider.getWithParams(userdata, "auth_token=" + authToken);
    return UserDataResponse.fromJson(response);
  }

  Future<MyWishlistResponse> fetchMyWishList(String authToken) async {
    final response =
        await _provider.getWithParams(my_wishlist, "auth_token=" + authToken);
    return MyWishlistResponse.fromJson(response);
  }

  Future<TopCourseResponse> fetchTopCourse(String authToken) async {
    final response =
        await _provider.getWithParams(top_courses, "auth_token=" + authToken);
    return TopCourseResponse.fromJson(response);
  }

  Future<AllPlansResponse> fetchAllPlans(
      String authToken, String offset) async {
    var parameter = "offset=$offset";

    if (authToken.isNotEmpty) {
      parameter = "auth_token=$authToken&offset=$offset";
    }

    final response = await _provider.getWithParamsV2(all_plans, parameter);

    return AllPlansResponse.fromJson(response);
  }

  Future<AllPlansResponse> fetchAllPlansFilter(
      String authToken, String offset, String planId, String packId) async {
    try {
      var parameter =
          "auth_token=$authToken&offset=$offset&category_id=$planId&package_id=$packId";
      final response = await _provider.getWithParamsV2(all_plans, parameter);
      return AllPlansResponse.fromJson(response);
    } catch (e) {
      print("FILTER ALL PLAN: " + e.toString());
      rethrow;
    }
  }

  Future<PlanDetailResponse> getPlanDetail(
      String authToken, String? planId) async {
    var parameter = "plan_id=$planId&auth_token=$authToken";
    final response = await _provider.getWithParamsV2(planDetail, parameter);

    // print("all pan=============================="+ response.toString());
    return PlanDetailResponse.fromJson(response);
  }

  Future<CategoriesResponse> fetchCategories(String authToken) async {
    final response =
        await _provider.getWithParams(categories, "auth_token=" + authToken);
    return CategoriesResponse.fromJson(response);
  }

  Future<FilterCourseResponse> fetchFilterCourse(
      String category,
      String? price,
      String? level,
      String? language,
      String? rating,
      String? searchString,
      String catName) async {
    // print("{{category}}" + level.toString());
    // print("{{category}}" + catName.toString());

    var msp = <String, dynamic>{
      'Category Name':
          (null != catName.toLowerCase()) ? catName.toLowerCase() : "all",
      'Category Id': category.toLowerCase() == 'all' ? 0 : int.parse(category),
      'Course Level': level,
      'Language': language,
      'Course Ratings': rating
    };
    print("-== $msp");
    WebEngagePlugin.trackEvent(TAG_COURSE_FILTER, msp);

    var parameter =
        "selected_category=$category&selected_price=$price&selected_level=$level&selected_language=$language&selected_rating=$rating&selected_search_string=$searchString";
    final response = await _provider.getWithParams(filter_course, parameter);
    return FilterCourseResponse.fromJson(response);
  }

  Future<FilterCourseResponse> fetchCategoryWiseCourse(
      String categoryId) async {
    var parameter = "category_id=$categoryId";
    final response =
        await _provider.getWithParams(category_wise_course, parameter);
    return FilterCourseResponse.fromJson(response);
  }

  Future<CourseDetailsByIdResponse> fetchCourseDetailsById(
      String authToken, String? courseId) async {
    var parameter = "auth_token=$authToken&course_id=$courseId";
    final response =
        await _provider.getWithParams(course_details_by_id, parameter);
    //log("CourseDetailsByID" + response.toString(), level: 1);
    return CourseDetailsByIdResponse.fromJson(response[0]);
  }

  Future<VideoResponse> fetchVideoLink(String url) async {
    final response = await _provider.getWithBaseUrl(url);
    return VideoResponse.fromJson(response);
  }

  Future<RemoveWishListResponse> removeWishListItem(
      String authToken, String? courseId) async {
    var parameter = "auth_token=$authToken&course_id=$courseId";
    final response =
        await _provider.getWithParams(toggle_wishlist_items, parameter);
    return RemoveWishListResponse.fromJson(response);
  }

  Future<UpdatePasswordResponse> updatePassword(
      UpdatePasswordRequest updatePasswordRequest) async {
    var json = jsonEncode(updatePasswordRequest.toJson());
    final response = await _provider.post(update_password, json);
    return UpdatePasswordResponse.fromJson(response);
  }

  Future<RegistrationResponse> fetchRegistration(
      RegistrationRequest registrationRequest) async {
    var json = jsonEncode(registrationRequest.toJson());
    final response = await _provider.post(registration, json);
    return RegistrationResponse.fromJson(response);
  }

  Future<ResetPasswodResponse> fetchResetPassword(
      ResetPasswordRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(reset_password, json);
    return ResetPasswodResponse.fromJson(response);
  }

  Future<ResetResponse> fetchReset(
      ResetRequest request, String? phoneNumber) async {
    var json = jsonEncode(request.toJson());
    final response = await _service.post("$reset/$phoneNumber", json);
    return ResetResponse.fromJson(response);
  }

  Future<SocialLoginResponse> socialLogin(SocialLoginRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(gmail_user_authentication, json);
    return SocialLoginResponse.fromJson(response);
  }

  // Future<FacebookUserProfile> facebookProfile(String token) async {
  //   final response = await _provider.getWithBaseUrl(
  //       'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
  //   return FacebookUserProfile.fromJson(response);
  // }

  Future<MyTransactionHistoryResponse> myTransactionHistory(
      GeneralTokenRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(my_transaction_history, json);
    return MyTransactionHistoryResponse.fromJson(response);
  }

  Future<MyBankHistoryResponse> myBankHistory(
      GeneralTokenRequest request) async {
    // var json = jsonEncode(request.toJson());
    final response = await _provider.getWithParams(
        my_bank_history, "auth_token=" + request.authToken!);
    return MyBankHistoryResponse.fromJson(response);
  }

  Future<AllPlansResponse> my_plan(GeneralTokenRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.postV2(my_plan_post, json);
    return AllPlansResponse.fromJson(response);
  }

  Future<EditProfileResponse> updateUserData(EditProfileRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(update_userdata, json);
    return EditProfileResponse.fromJson(response);
  }

  Future<AffiliateResponse> updateAffiliates(AffiliateRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(affiliatesRegistration, json);
    return AffiliateResponse.fromJson(response);
  }

  Future<UserImageResponse> uploadUserImage(File file, String token) async {
    final response = await _provider.uploadFile(upload_user_image, file, token);
    return UserImageResponse.fromJson(response);
  }

  Future<EnrolledToFreeCourseResponse> enrolledToFreeCourse(
      EnrolledToFreeCourseRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(enrolled_to_free_course, json);
    return EnrolledToFreeCourseResponse.fromJson(response);
  }

  Future<SmartCoursePaymentResponse> smartCoursePayment(
      SmartCoursePaymentRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(smart_course_payment, json);
    log("==>>PAYMENTREQUEST" + json.toString());
    log("==>>PAYMENTRESPONSE" + response.toString());
    return SmartCoursePaymentResponse.fromJson(response);
  }

  Future<SmartCoursePaymentResponse> smartPlanPayment(
      SmartPlanPaymentRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(smart_course_payment, json);
    // print("THISISTOFOCUS" + response.toString());
    return SmartCoursePaymentResponse.fromJson(response);
  }

  Future<SectionResponse> section(String? courseId, String authToken) async {
    var parameter = "auth_token=$authToken&course_id=$courseId";
    final response = await _provider.getWithParams(sections, parameter);
    return SectionResponse.fromJson(response);
  }

  Future<SaveCourseProgressResponse> saveCourseProgress(
      String? lessonId, String authToken, String progress) async {
    var parameter =
        "auth_token=$authToken&lesson_id=$lessonId&progress=$progress";
    final response =
        await _provider.getWithParams(save_course_progress, parameter);
    return SaveCourseProgressResponse.fromJson(response);
  }

  //changed
  Future<FilterCourseResponse> coursesBySearchString(
      String searchString, String? plain) async {
    var parameter = "q=$searchString";

    if (plain != null && plain.isNotEmpty) {
      WebEngagePlugin.trackEvent(
          TAG_COURSE_SEARCH, <String, String>{'Search Keyword': plain});
    }

    print("searchlog ====== $plain");

    final response = await _provider.getWithParamsGithub(
        courses_by_search_string, parameter);
    return FilterCourseResponse.fromJsonGithub(response);
  }

  Future<FilterCourseResponse> coursesBySearchStringOld(
      String searchString) async {
    var parameter = "search_string=$searchString";
    final response =
        await _provider.getWithParams(courses_by_search_string, parameter);
    return FilterCourseResponse.fromJson(response);
  }

  Future<SubscriptionTypeResponse> subscriptionType(
      String planId, String authToken) async {
    var parameter = "plan_id=$planId&auth_token=$authToken";
    final response =
        await _provider.getWithParams(subscription_type, parameter);
    return SubscriptionTypeResponse.fromJson(response);
  }

  Future<AllPlansResponse> searchPlan(SearchPlanRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.postV2(search_plan, json);
    return AllPlansResponse.fromJson(response);
  }

  Future<SmartCoursePaymentResponse> smartPaymentPlan(
      SmartPlanPayment request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(smart_course_payment, json);
    return SmartCoursePaymentResponse.fromJson(response);
  }

  Future<ReviewResponse> getReviews(String authToken, String? courseId) async {
    var parameter = "auth_token=$authToken&course_id=$courseId";
    final response = await _provider.getWithParams(reviews, parameter);
    return ReviewResponse.fromJson(response);
  }

  Future<ReviewResponse> reviewAdded(ReviewAddedRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(addReview, json);
    return ReviewResponse.fromJson(response);
  }

  Future<MyCourseResponse> fetchCoursesExpire(String authToken) async {
    final response =
        await _provider.getWithParams(coursesExpire, "auth_token=" + authToken);
    return MyCourseResponse.fromJson(response);
  }

  Future<LogoutResponse> fetchLogout(String authToken) async {
    final response =
        await _provider.getWithParams(logoutSingle, "auth_token=" + authToken);
    return LogoutResponse.fromJson(response);
  }

  Future<LogoutResponse> fetchLogoutEveryWhere(String authToken) async {
    final response =
        await _provider.getWithParams(logoutEveryWhere, "user_id=" + authToken);
    return LogoutResponse.fromJson(response);
  }

  Future<BankDetailResponse> fetchBankAccountList(String authToken) async {
    final response =
        await _provider.getWithParams(bank_details, "auth_token=" + authToken);
    return BankDetailResponse.fromJson(response);
  }

  Future<BankSubmitResponse> bankSubmitResponse(
      String path, String token, Map<String, String> maps) async {
    final response = await _provider.uploadFileWithFields(
        submit_deposited_slip, path, token, maps);
    return BankSubmitResponse.fromJson(response);
  }

  Future<InAppValidateResponse> validateInApp(
      InAppReceiptValidateRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(validate_receipt, json);
    return InAppValidateResponse.fromJson(response);
  }

  Future<CoursesResponse> fetchCoursesDetails(
      CoursesRequest coursesRequest) async {
    var json = jsonEncode(coursesRequest.toJson());
    final response = await _provider.post(coursesDetails, json);
    return CoursesResponse.fromJson(response);
  }

  Future<Entrance_config> getEntranceConfig(GeneralTokenRequest request) async {
    var json = jsonEncode(request.toJson());
    final response = await _provider.post(entrance_config, json);
    return Entrance_config.fromJson(response);
  }

  Future<RelatedPlanResponse> getRelatedPlans(String? courseId) async {
    var parameter = "course_id=$courseId";
    final response =
        await _provider.getWithParams(relatedCoursePlan, parameter);
    return RelatedPlanResponse.fromJson(response);
  }

  Future<CertificateStatusResponse> checkCertificate(
      String authToken, String? courseId) async {
    log("Checking certificate", level: 2);
    var parameter = "auth_token=$authToken&course_id=$courseId";
    final response =
        await _provider.getWithParams(checkCertificateStr, parameter);
    log(response.runtimeType.toString(), level: 2);
    return CertificateStatusResponse.fromJson(response);
  }

  Future<http.Response> getCertificate(
      String authToken, String courseId) async {
    Map parameter = {"auth_token": authToken, "course_id": courseId};
    final response = await http
        .post(Uri.parse(base_url + "generateCertificate"), body: parameter);
    // await _provider.postDirectResponse(
    //     "generateCertificate", parameter.toString());
    return response;
  }

  Future<CurriculumDataResModel> fetchInitialCurriculumData(
      int courseID) async {
    final res = await http.get(
      Uri.parse(
          "https://demo.mero.school/Apiv2/course?course_id=$courseID&auth_token="),
    );
    final x = jsonDecode(res.body);
    // print(x["data"]["sections"]);
    return curriculumDataResModelFromMap(res.body);
  }

  Future<SectionDataResModel> getSection(String courseID, String sectionID,
      [String parentID = "0"]) async {
    var parameter =
        "course_id=$courseID&section_id=$sectionID&parent_id=$parentID";
    final res = await _provider.getWithParamsV2(getLessons, parameter);
    return SectionDataResModel.fromMap(res);
  }

  Future<InAppPaymentResponse> getInAppResponse(
      InAppPaymentRequest inAppPaymentRequest) async {
    try {
      final res = await http.post(
        // Uri.parse("https://demo.mero.school/Api/googlePay"),
        Uri.parse("https://mero.school/Api/googlePay"),
        body: inAppPaymentRequestToMap(inAppPaymentRequest),
        headers: {"Content-Type": "application/json"},
      );
      return inAppPaymentResponseFromMap(res.body);
    } catch (e) {
      print("InAppPayment Issue: " + e.toString());
      rethrow;
    }
  }

  Future<GooglePriceResModel> getGooglePrice(int courseID, String token) async {
    try {
      final res = await http.get(
        Uri.parse(
            "https://mero.school/Apiv2/getGooglePrice?course_id=$courseID&auth_token=$token"),
        // Uri.parse(
        //     "https://demo.mero.school/Apiv2/getGooglePrice?course_id=$courseID&auth_token=$token"),
      );
      return googlePriceResModelFromMap(res.body);
    } catch (e) {
      print(
        "Google Price Fetching error: " + e.toString(),
      );
      rethrow;
    }
    // var parameters = "course_id=$courseID&auth_token=$token";
    // final res = _provider.getWithParamsV2(googlePrice, parameters);
    // return GooglePriceResModel.fromMap(res);
  }
}
