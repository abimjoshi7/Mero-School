// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   InAppNotifications().setStatus(true);
//   print("Handling a background message: ${message.messageId}");
//   PushNotificationService().navigateToPost(message.data);
// }
//
// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final String urlString = dotenv.env["apiUrl"].toString();
//   final dataStorage = GetStorage();
//
//   Future initialise() async {
//     if (Platform.isIOS) {
//       _fcm.requestPermission();
//     }
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       // print('Message data: ${message.data}');
//       Map data = message.data;
//       InAppNotifications().setStatus(true);
//       // print(screen);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       navigateToPost(message.data);
//     });
//     FirebaseMessaging.onBackgroundMessage((message) async {
//       navigateToPost(message.data);
//       return null;
//     });
//   }
//
//   final message = await
//   FirebaseMessaging.instance.getInitialMessage();
//   if (message == null) {
//   return null;
//   } else {
//   return navigateToPost(message.data);
//   }
//
//   void navigateToPost(Map<String, dynamic> message) {
//     var screen = message["type"];
//     print(message);
//   }
// }
