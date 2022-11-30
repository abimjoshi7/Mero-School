import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationTestPage extends StatefulWidget {
  @override
  _NotificationTestPageState createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  int id = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notificaiton test"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                print("click test type 1");

                notificationWithImageV2();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Test Type 1"),
              )),
          TextButton(
              onPressed: () {
                print("click test type 1");

                notificationWithImageV2();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Test Type 2"),
              ))
        ], //notificationWithImageV2
      ),
    );
  }

  void notificationWithImageV2() async {
    var isPush = true;
    String channelId = '1234';
    String channelTitle = 'Android Channel';
    String channelDescription = 'Default Android Channel for notifications';
    Priority notificationPriority = Priority.high;
    Importance notificationImportance = Importance.max;

    final String bigPicturePath = await _downloadAndSaveFile(
        "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_80.jpg?time=1641981942",
        'bigPicture.jpg');

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            largeIcon: FilePathAndroidBitmap(bigPicturePath));

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
      styleInformation: bigPictureStyleInformation,
      icon: 'for_icon',
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (isPush) {
      await flutterLocalNotificationsPlugin.show(
          id++, "Test title message", "Test message body", notificationDetails,
          payload: "allplan|62|");
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
