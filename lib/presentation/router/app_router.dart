import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/pages/account/about_us_page.dart';
import 'package:mero_school/presentation/pages/account/affiliate/affiliate_dashboard.dart';
import 'package:mero_school/presentation/pages/account/affiliate/assigned_coupons.dart';
import 'package:mero_school/presentation/pages/account/affiliate/coupon_report.dart';
import 'package:mero_school/presentation/pages/account/affiliate/coupon_used_report.dart';
import 'package:mero_school/presentation/pages/account/affiliate/earning_report.dart';
import 'package:mero_school/presentation/pages/account/affiliate/payment_history.dart';
import 'package:mero_school/presentation/pages/account/edit_profile/edit_profile_page.dart';
import 'package:mero_school/presentation/pages/account/profile/change_password/update_password_page.dart';
import 'package:mero_school/presentation/pages/account/profile/profile_page.dart';
import 'package:mero_school/presentation/pages/account/sign_up/register_page.dart';
import 'package:mero_school/presentation/pages/account/sign_up/verify_otp/verify_otp_page.dart';
import 'package:mero_school/presentation/pages/account/signin/change_password_page.dart';
import 'package:mero_school/presentation/pages/account/signin/login_page.dart';
import 'package:mero_school/presentation/pages/bank_transfer/bank_transfer.dart';
import 'package:mero_school/presentation/pages/bank_transfer/in_app_product_list.dart';
import 'package:mero_school/presentation/pages/course/all_course/all_course_page.dart';
import 'package:mero_school/presentation/pages/course/all_plans/all_plans_page.dart';
import 'package:mero_school/presentation/pages/course/all_plans/plans_subcription_page.dart';
import 'package:mero_school/presentation/pages/course_details/course_details_page.dart';
import 'package:mero_school/presentation/pages/course_details/youtube_video_player.dart';
import 'package:mero_school/presentation/pages/home_page.dart';
import 'package:mero_school/presentation/pages/my_course/expired_course/expired_course_page.dart';
import 'package:mero_school/presentation/pages/my_course/my_transaction_history/my_bank_history_page.dart';
import 'package:mero_school/presentation/pages/my_course/my_transaction_history/my_plan_history_page.dart';
import 'package:mero_school/presentation/pages/my_course/my_transaction_history/my_transaction_history_page.dart';
import 'package:mero_school/presentation/pages/notification/notification_page.dart';
import 'package:mero_school/presentation/pages/payment/smart_payment_page.dart';
import 'package:mero_school/presentation/pages/payment/web_page.dart';
import 'package:mero_school/presentation/pages/payment/web_page_entrance.dart';
import 'package:mero_school/presentation/pages/splash_page.dart';
import 'package:mero_school/presentation/pages/video_player/hls_playlist_player_page.dart';
import 'package:mero_school/presentation/pages/wish_list/wish_list_page.dart';
import 'package:mero_school/presentation/pages/wish_list/my_cart/my_carts_page.dart';
import 'package:mero_school/quiz/quiz_answer_page.dart';
import 'package:mero_school/quiz/quiz_home_page.dart';
import 'package:mero_school/quiz/quiz_play_page.dart';
import 'package:mero_school/quiz/quiz_result_page.dart';
import 'package:mero_school/test/notification_test_page.dart';
import 'package:mero_school/test/test_page.dart';

import '../../test/test.dart';
import '../pages/account/affiliate/create_affiliate.dart';
import '../pages/feedback_form.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case splash_page:
        return MaterialPageRoute(
          builder: (_) => SplashPage(),
        );
      case test:
        return MaterialPageRoute(
          builder: (_) => NotificationTestPage(),
        );

      case home_page:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case login_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LoginPage(),
        );
      case register_page:
        return MaterialPageRoute(
          builder: (_) => RegisterPage(),
        );
      case change_password_page:
        return MaterialPageRoute(
          builder: (_) => ChangePasswordPage(),
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
        );
      case all_course:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AllCoursePage(),
        );
      case all_plans:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AllPlansPage(
            argument: settings.arguments,
            isBottomSheet: false,
          ),
        );
      case course_details:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CourseDetails(),
        );
      case youtube_video_player:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => YoutubeVideoPlayer(),
        );
      case video_player:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HLSPlayListPlayerPage(),
          // builder: (_) => HLSVideoPlayerPage(),
        );

      // case video_player_test:
      //   return MaterialPageRoute(
      //     settings: settings,
      //     // builder: (_) => HLSPlayListPlayerPage(),
      //     builder: (_) => HLSVideoPlayerPage(),
      //   );

      case profile_change_password:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => UpdatePasswordPage(),
        );
      case verify_otp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VerifyOtpPage(),
        );
      case my_transaction_history:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyTransactionHistoryPage(),
        );

      case bank_transfer_history_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyBankHistoryPage(),
        );

      case my_plan_history_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyPlanHistoryPage(),
        );

      case expired_course_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ExpiredCoursePage(),
        );
      case my_carts:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyCartsPage(),
        );

      case about_us:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AboutUsPage(),
        );

      case edit_profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EditProfilePage(),
        );
      case web_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WebPage(),
        );

      case web_page_entrance:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WebPageEntrance(),
        );

      case smart_payment_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SmartPaymentPage(),
        );
      case plans_details_page:
        return MaterialPageRoute(
          settings: settings,
          // builder: (_) => PlansSubscriptionPageV2(),
          builder: (_) => PlansSubscriptionPage(),
        );

      case notification_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => NotificationPage(),
        );

      case bank_transfer_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BankTransferPage(),
        );

      case quiz_home_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuizHomePage(),
        );

      //quiz_play_page
      case quiz_play_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuizPlayPlay(),
        );

      case quiz_result_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuizResultPage(),
        );

      case quiz_answer_page:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuizAnswerPage(),
        );

      //in_app_product_list

      case in_app_product_list:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => InAppProductsList(),
        );

      case route_wish_list:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WishListPage(),
        );

      case entrance_app:
        return MaterialPageRoute(
            settings: settings, builder: (_) => TestPage());

      case feedback_form:
        return MaterialPageRoute(
            settings: settings, builder: (_) => FeedbackForm());
      case affiliate_page:
        return MaterialPageRoute(
            settings: settings, builder: (_) => CreateAffiliate());

      case affiliate_dashboard:
        return MaterialPageRoute(
            settings: settings, builder: (_) => AffiliateDashboard());

      case assigned_coupons:
        return MaterialPageRoute(
            settings: settings, builder: (_) => AssignedCoupons());

      case coupon_report:
        return MaterialPageRoute(
            settings: settings, builder: (_) => CouponReport());

      case coupon_used_report:
        return MaterialPageRoute(
            settings: settings, builder: (_) => CouponUsedReport());

      case payment_history:
        return MaterialPageRoute(
            settings: settings, builder: (_) => PaymentHistory());

      case earning_report:
        return MaterialPageRoute(
            settings: settings, builder: (_) => EarningReport());

      case est:
        return MaterialPageRoute(settings: settings, builder: (_) => Est());
      case random:
        return MaterialPageRoute(builder: (_) => Random());
      default:
        return null;
    }
  }
}
