import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mero_school/business_login/blocs/CurrentPlayingNotifier.dart';
import 'package:mero_school/business_login/blocs/all_plans_bloc.dart';
import 'package:mero_school/business_login/blocs/course_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:mero_school/networking/my_notification.dart';
import 'package:mero_school/presentation/constants/api_end_point.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/router/app_router.dart';
import 'package:mero_school/test/counter_cubit.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

FlutterLocalNotificationsPlugin fitNotification =
    FlutterLocalNotificationsPlugin();
String? selectedNotificationPayload;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

bool _initialUriIsHandled = false;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void afterIntifirebase() {
  FirebaseMessaging.instance
      .subscribeToTopic(topic)
      .onError((error, stackTrace) => {print(error)});

  FirebaseMessaging.instance.getToken().then((value) => {
        Preference.setString(fcm_token, value),
        //print('###tokenFetched')
      });

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
  //   await Firebase.initializeApp();
  //   displayNotification(message);
  // });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WebEngagePlugin _webEngagePlugin = new WebEngagePlugin();
  HttpOverrides.global = MyHttpOverrides();

  try {
    await Firebase.initializeApp().then((value) {
      //print("#firebaseinitialzied");
      afterIntifirebase();
    });
  } catch (e) {
    //print(e);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // try {
  //   await setupLocator();
  // } catch (e) {
  //   //print(e);
  // }

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await fitNotification.getNotificationAppLaunchDetails();

  //print('####NotificationAppLauchDetails');

  final uri = await getInitialUri();

  //print("#####uri get");

  String initialRoute = splash_page;

  //debug

  String id = "0";

  //
  // initialRoute = all_course;
  // id = "6";

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails?.notificationResponse!.payload;

    print("payload $selectedNotificationPayload");

    var parts = selectedNotificationPayload?.split(SEPERATOR);

    if (parts != null) {
      if (parts[0] == "course" ||
          parts[0].toLowerCase() == "coursedetails" ||
          parts[0].toLowerCase() == "coursedetail") {
        id = parts[1];
        //course details page
        initialRoute = course_details;
      } else if (parts[0].toLowerCase() == "allcourse") {
        initialRoute = all_course;
        if (parts.length > 1) {
          id = parts[1];
        }
        print("payload: $initialRoute $id");
      } else if (parts[0].toLowerCase() == "allplan") {
        if (parts.length > 1) {
          id = parts[1];
        }
        initialRoute = "/allPlans";
      } else if (parts[0].toLowerCase() == "web") {
        id = parts[1];
        initialRoute = web_page;
      } else if (parts[0].toLowerCase() == "plan") {
        id = parts[1];
        initialRoute = plans_details_page;
      } else if (parts[0].toLowerCase() == "quiz") {
        initialRoute = web_page_entrance;
      } else if (parts[0].toLowerCase() == "wishlist") {
        initialRoute = route_wish_list;
      } else if (parts[0].toLowerCase() == "carts") {
        initialRoute = my_carts;
      } else {
        initialRoute = notification_page;
      }
    } else {
      //notification page
      initialRoute = notification_page;
    }
  }

  print("...... initial routes  $initialRoute");

  // initialRoute = quiz_home_page;
  // initialRoute = test;

  //print("uri:print $uri");

  if (uri == null) {
    //print('no initial uri');

  } else {
    String path = uri.toString();
    //print('${path} atcual path');
    if (path.toLowerCase().contains("coursedetails") ||
        path.toLowerCase().contains("/home/course")) {
      String idStr = uri.path.substring(uri.path.lastIndexOf('/') + 1);
      //print("id: $idStr");
      id = idStr;
      initialRoute = course_details;
    }
  }

  //print("######save=== initial route $initialRoute");

  // await GetStorage.init();

  runZonedGuarded(() {
    runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserStateViewModel()),
            ChangeNotifierProvider(
                create: (context) => CurrentPlayingNotifier()),
            // Provider(create: (context) => DeepLinkBloc()),
            Provider(create: (context) => CourseBloc()),
            Provider(create: (context) => AllPlansBloc())
          ],
          child: MyAppStateFull(
              appRouter: AppRouter(), initialRoute: initialRoute, id: id)
          // child:  TestPage()
          ),
    );
  }, FirebaseCrashlytics.instance.recordError);
}

class MyAppStateFull extends StatefulWidget {
  AppRouter appRouter;
  String initialRoute;
  String id;

  MyAppStateFull(
      {Key? key,
      required this.appRouter,
      required this.initialRoute,
      required this.id})
      : super(key: key);

  //const AnimatedList({
  //     Key? key,
  //     required this.itemBuilder,
  //     this.initialItemCount = 0,
  //     this.scrollDirection = Axis.vertical,
  //     this.reverse = false,
  //     this.controller,
  //     this.primary,
  //     this.physics,
  //     this.shrinkWrap = false,
  //     this.padding,
  //     this.clipBehavior = Clip.hardEdge,
  //   }) : assert(itemBuilder != null),
  //        assert(initialItemCount != null && initialItemCount >= 0),
  //        super(key: key);

  @override
  MyApp createState() => MyApp();
}

class MyApp extends State<MyAppStateFull> {
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;

  @override
  void dispose() {
    super.dispose();

    _sub.cancel();
    _purchaseUpdatedSubscription!.cancel();
    _purchaseUpdatedSubscription = null;
    _purchaseErrorSubscription!.cancel();
    _purchaseErrorSubscription = null;
  }

  @override
  void initState() {
    super.initState();

    _handleIncomingLinks();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("${message?.from} =--> from");

      if (message != null) {
        MyNotification().initMessaging(message, isPush: false);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      displayNotification(message);
      print("${message.from} =--> onnMessage");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("${message.from} =--> onMessageOpenedApp");
      displayNotification(message);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    asyncInitState();

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      //print('purchase-updated: $productItem');
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      //print('purchase-error: $purchaseError');
    });
  }

  void asyncInitState() async {
    await FlutterInappPurchase.instance.initialize();
  }

  late StreamSubscription _sub;

  Future<void> _handleIncomingLinks() async {
    //
    // FirebaseDynamicLinks.instance.onLink(
    //   onSuccess: (PendingDynamicLinkData dynamicLink) async{
    //     final Uri deepLink = dynamicLink.link;
    //     if(deepLink!=null){
    //       //print("firebaseDynamicLink: ${deepLink}");
    //
    //
    //
    //     }
    //
    //   }
    // );

    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.

      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        //print('got uri: $uri here1');

        String path = uri.toString();

        if (path.toLowerCase().contains("coursedetails") ||
            path.toLowerCase().contains("course")) {
          String idStr = path.substring(path.lastIndexOf('/') + 1);
          Navigator.pushNamed(
              navigatorKey.currentState!.overlay!.context, course_details,
              arguments: <String, String>{'course_id': idStr});
        } else if (path.toLowerCase().contains("allcourse")) {
          String idStr = path.substring(path.lastIndexOf('/') + 1);
          if (idStr.toLowerCase() == "allcourse") {
            idStr = all;
          }

          Navigator.pushNamed(
              navigatorKey.currentState!.overlay!.context, all_course,
              arguments: <String, String>{'course_id': "$idStr"});
        } else if (path.toLowerCase().contains("allplan")) {
          String idStr = path.substring(path.lastIndexOf('/') + 1);

          if (idStr.isNotEmpty) {
            Navigator.pushNamed(
                navigatorKey.currentState!.overlay!.context, "/allPlans",
                arguments: <String, String>{'id': "$idStr"});
          } else {
            Navigator.pushNamed(
              navigatorKey.currentState!.overlay!.context,
              "/allPlans",
            );
          }
        } else if (path.toLowerCase().contains("plan")) {
          String idStr = path.substring(path.lastIndexOf('/') + 1);
          Navigator.pushNamed(
              navigatorKey.currentState!.overlay!.context, plans_details_page,
              arguments: <String, String>{'plan_id': idStr});
        } else if (path.toLowerCase().contains("quiz")) {
          Navigator.of(navigatorKey.currentState!.overlay!.context)
              .pushNamed(web_page_entrance);
        } else if (path.toLowerCase().contains("wishlist")) {
          Navigator.of(navigatorKey.currentState!.overlay!.context)
              .pushNamed(route_wish_list);
        } else if (path.toLowerCase().contains("carts")) {
          Navigator.of(navigatorKey.currentState!.overlay!.context)
              .pushNamed(my_carts);
        }
      }, onError: (Object err) {
        if (!mounted) return;
        //print('got err: $err');
      });
    }
  }

  // MyApp(
  //     {Key key,
  //     @required this.appRouter,
  //     @required this.initialRoute,
  //     @required this.id})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/5385893.png"), context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: app_name,
        navigatorKey: navigatorKey,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        theme: ThemeData(
            primaryColor: HexColor.fromHex(colorPrimary),
            primaryColorDark: HexColor.fromHex(colorPrimaryDark),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            // fontFamily: 'Roboto'
            fontFamily: 'Sans',
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: HexColor.fromHex(colorAccent))),
        debugShowCheckedModeBanner: false,
        initialRoute: widget.initialRoute,
        // initialRoute: test,
        onGenerateRoute: widget.appRouter.onGenerateRoute,
        onGenerateInitialRoutes: (String initialRouteName) {
          //print("intitialRouteName:${initialRouteName}");

          return [
            widget.appRouter.onGenerateRoute(RouteSettings(
                name: widget.initialRoute,
                arguments: <String, String>{
                  'course_id': widget.id,
                  'id': widget.id
                }))!,
          ];
        },
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // print("--->onBckgournd message ${message.toString()}");
  // await Firebase.initializeApp();
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  displayNotification(message);

  //print("Handling a background message: ${message.messageId}");
}

void displayNotification(RemoteMessage message) {
  MyNotification().initMessaging(message);
}

//await FirebaseMessaging.instance.subscribeToTopic('TopicToListen');
