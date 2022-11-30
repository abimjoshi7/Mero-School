import 'dart:async';

import 'package:drift/drift.dart';
import 'package:mero_school/business_login/blocs/base_bloc.dart';

import '../../app_database.dart';

class NotificationBloc extends BaseBloc {
  var db = AppDatabase.instance;

  Future<List<NotificationModelData>> getNotificationData() async {
    return await db.select(db.notificationModel).get();
  }

  Stream<List<NotificationModelData>> get unreadMessage {
    return (db.select(db.notificationModel)
          ..where((tbl) => tbl.isRead.equals(false)))
        .watch();
  }

  //(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)

  Stream<List<NotificationModelData>> get unallMessage {
    return (db.select(db.notificationModel)
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .watch();
  }

  checkCount() async {
    int count = 0;

    List<NotificationModelData> data = await getNotificationData();
    data.forEach((element) {
      if (!element.isRead) {
        count = count + 1;
      }
    });
  }

  //function Delete notification
  //function delete all notificaiton

  deleteAllNotifications() async {
    return await db.delete(db.notificationModel).go();
  }

  deleteSingleNotification(NotificationModelData data) async {
    return await (db.delete(db.notificationModel)
          ..where((tbl) => tbl.id.equals(data.id)))
        .go();
  }

  insertNotificationModel(NotificationModelData notificationModel) async {
    await (db.into(db.notificationModel).insert(notificationModel));

    // checkCount();
  }

  //
  // Future<int> getUnreadNotification() async {
  //   int count = 0;
  //   List<NotificationModelData> data = await getNotificationData();
  //   data.forEach((element) {
  //     if (!element.isRead) {
  //       count = count+1;
  //     }
  //   });
  //
  //
  //
  //
  //
  //   // await getNotificationData().then((value) {
  //   //   value.forEach((element) {
  //   //     if (element.isRead) {
  //   //       count++;
  //   //     }
  //   //   });
  //   // });
  //   // // if(count==null){
  //   // //   count =0;
  //   // // }
  //   debugPrint("My test coutn count: $count");
  //   return count;
  // }

  setReadAllNotification() async {
    await getNotificationData().then((value) {
      value.forEach((element) {
        if (!element.isRead) {
          var newModel = NotificationModelData(
              id: element.id,
              courseId: element.courseId,
              icon: element.icon,
              title: element.title,
              description: element.description,
              type: element.type,
              notifyTime: element.notifyTime,
              isRead: true);
          updateQuery(newModel);
        }
      });
    });
  }

  void setRead(NotificationModelData element) async {
    var newModel = NotificationModelData(
        id: element.id,
        courseId: element.courseId,
        icon: element.icon,
        title: element.title,
        description: element.description,
        type: element.type,
        notifyTime: element.notifyTime,
        isRead: true);

    await db.update(db.notificationModel).write(newModel);

    // await locator<AppDatabase>().NotificationModel(newModel);
  }

  void updateQuery(NotificationModelData element) async {
    await db.update(db.notificationModel).write(element);

    // await locator<AppDatabase>().updateNotificationData(element);
  }
}
