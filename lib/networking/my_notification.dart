import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

const String SEPERATOR = "|";
String? body = "";

class MyNotification {
  void initMessaging(RemoteMessage message, {isPush: true}) {
    var androidInit = AndroidInitializationSettings('ic_notification');
    var iosInit = DarwinInitializationSettings();
    var initSetting =
        InitializationSettings(android: androidInit, iOS: iosInit);

    fitNotification.initialize(initSetting,
        onDidReceiveNotificationResponse: onSelectNotification);
    var rand = new Random();
    String? title = "";
    String? icon = "";

    String? type = "";
    String? itemId = "";

    String link = "";

    print("-->>Not ${message.notification?.title}");
    print("-->>Not ${message.notification?.title}");

    if (message.notification != null) {
      //
      title = "${message.notification?.title}";
      body = "${message.notification?.body}";
      icon = "${message.notification?.android?.imageUrl}";

      if (Platform.isAndroid) {
        icon = "${message.notification?.android?.imageUrl}";
      } else {
        icon = "${message.notification?.apple?.imageUrl}";
      }
    }

    print("alldata: ${message.data.toString()}");
    print("source: ${message.data['source']}");

    if (message.data['source'] == "webengage") {
      isPush = true;

      Map<String, dynamic> messageData =
          jsonDecode(message.data['message_data']);
      print("identifier: ${messageData.toString()}");

      if (messageData.containsKey("title")) {
        title = messageData["title"];
        body = messageData["message"];
      }

      if (messageData.containsKey("expandableDetails")) {
        Map<String, dynamic> expDetail = messageData["expandableDetails"];
        if (expDetail.containsKey("image")) {
          icon = expDetail["image"];
        }

        if (expDetail.containsKey("style")) {
          if (expDetail['style'] == "RATING_V1" ||
              expDetail['style'] == "CAROUSEL_V1") {
            isPush = false;
          }
        }
      }

      // if(messageData.containsKey("cta")){
      //   Map<String, dynamic> cta = messageData["cta"];
      //   if(cta.containsKey("actionLink")){
      //     print("-->actionLInk ${cta['actionLink']}");
      //     type = "web";
      //     String link = cta['actionLink'];
      //
      //     // String modified = link.replaceAll("w://p/open_url_in_browser/", "");
      //
      //     itemId = "${link}";
      //   }
      // }

      if (messageData.containsKey("custom")) {
        List<dynamic> customData = messageData['custom'];
        print("selement1: ${customData.toString()}");

        customData.forEach((element) {
          Map<String, dynamic> maps = element;

          var key = maps['key'];
          var value = maps['value'];

          print("maps: $maps $key $value");

          if (key == "itemId") {
            itemId = value;
          }

          if (key == "type") {
            type = value;
          }
        });
      }
    } else {
      if (message.data.containsKey("icon")) {
        icon = message.data['icon'];
      }

      if (message.data.containsKey("title")) {
        title = message.data['title'];
        body = message.data['body'];
      }

      if (message.data.containsKey("type")) {
        type = message.data['type'];
      }

      if (message.data.containsKey("itemId")) {
        itemId = message.data["itemId"];
      }
    }

    if (title?.isNotEmpty == true && body?.isNotEmpty == true) {
      showNotification(rand.nextInt(1000), title, body, icon,
          "$type$SEPERATOR$itemId$SEPERATOR$icon",
          isPush: isPush);
    }
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<void> showNotification(int notificationId, String? notificationTitle,
      String? notificationContent, String? icon, String payload,
      {String channelId = '1234',
      String channelTitle = 'Android Channel',
      String channelDescription = 'Default Android Channel for notifications',
      Priority notificationPriority = Priority.high,
      Importance notificationImportance = Importance.max,
      bool isPush = true}) async {
    //with icon
    if (icon != null && icon.isNotEmpty) {
      final String bigPicturePath =
          await _downloadAndSaveFile(icon, 'bigPicture.jpg');

      print("==reached Here: $bigPicturePath");

      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
              largeIcon: FilePathAndroidBitmap(bigPicturePath));

      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        channelId, channelTitle,
        channelDescription: channelDescription,
        playSound: false,
        importance: notificationImportance,
        priority: notificationPriority,
        styleInformation: bigPictureStyleInformation,
        icon: 'for_icon',
        // color: const Color.fromARGB(255, 106, 0, 2),
        // ledColor: const Color.fromARGB(255, 106, 0, 2),
        // ledOnMs: 1000,
        // ledOffMs: 500
      );

      final DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(attachments: <DarwinNotificationAttachment>[
        DarwinNotificationAttachment(bigPicturePath)
      ]);
    
      final NotificationDetails notificationDetails = NotificationDetails(
          iOS: iOSPlatformChannelSpecifics,
          macOS: iOSPlatformChannelSpecifics,
          android: androidPlatformChannelSpecifics);

      if (isPush) {
        await fitNotification.show(notificationId, notificationTitle,
            notificationContent, notificationDetails,
            payload: payload);
      }
    } else {
      //with out icon
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        channelId,
        channelTitle,
        channelDescription: channelDescription,
        playSound: false,
        importance: notificationImportance,
        priority: notificationPriority,
        icon: 'for_icon',
        styleInformation: BigTextStyleInformation(body!),
        // color: const Color.fromARGB(255, 106, 0, 2),
        // ledColor: const Color.fromARGB(255, 106, 0, 2),
        // ledOnMs: 1000,
        // ledOffMs: 500
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      if (isPush) {
        await fitNotification.show(notificationId, notificationTitle,
            notificationContent, platformChannelSpecifics,
            payload: payload);
      }
    }

    var parts = payload.split(SEPERATOR);
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(now);

    NotificationModelData model = NotificationModelData(
        courseId: parts[1],
        icon: "$icon",
        title: notificationTitle.toString(),
        description: notificationContent.toString(),
        type: parts[0],
        notifyTime: formattedDate,
        isRead: false,
        id: now.millisecondsSinceEpoch.toString());

    print("--payload $payload");

    print(
        "--reaadyToInsert ${model.title} ${model.description} ${model.notifyTime}");
    var db = AppDatabase.instance;
    db.into(db.notificationModel).insert(model);

    // await locator<AppDatabase>().insertNotificationData(model);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<dynamic> onSelectNotification(NotificationResponse? notificationResponse) async {
    selectedNotificationPayload = notificationResponse?.payload;

    print("onSelectNotification");

    var parts = notificationResponse?.payload?.split(SEPERATOR);

    if (parts?[0].toLowerCase() == "course") {
      //course details page
      Navigator.pushNamed(
          navigatorKey.currentState!.overlay!.context, course_details,
          arguments: <String, String>{
            'course_id': parts![1],
            'thumbnail': parts[2]
          });
    } else if (parts?[0].toLowerCase() == "web") {
      Navigator.pushNamed(navigatorKey.currentState!.overlay!.context, web_page,
          arguments: <String, String>{'paymentUrl': "${parts?[1]}"});
    } else if (parts?[0].toLowerCase() == "allcourse") {
      Navigator.pushNamed(
          navigatorKey.currentState!.overlay!.context, all_course,
          arguments: <String, String>{'course_id': "${parts?[1]}"});
    } else if (parts?[0].toLowerCase() == "plan") {
      Navigator.pushNamed(
          navigatorKey.currentState!.overlay!.context, plans_details_page,
          arguments: <String, String>{'plan_id': "${parts?[1]}"});
    } else if (parts?[0].toLowerCase() == "allplan") {
      Navigator.pushNamed(
          navigatorKey.currentState!.overlay!.context, all_plans,
          arguments: <String, String>{'id': "${parts?[1]}"});
    } else if (parts?[0].toLowerCase() == "quiz") {
      Navigator.of(navigatorKey.currentState!.overlay!.context)
          .pushNamed(web_page_entrance);
    } else {
      //notification page
      Navigator.pushNamed(
          navigatorKey.currentState!.overlay!.context, notification_page);
    }

    debugPrint("onClick $notificationResponse");
  }
}
