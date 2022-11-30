import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'data/models/database/my_cart_model.dart';
import 'data/models/database/notification_model.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';


LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}


@DriftDatabase(tables: [MyCartModel, NotificationModel])
class AppDatabase extends _$AppDatabase {

  static final AppDatabase _instance = AppDatabase(_openConnection());

  static AppDatabase get instance => _instance;

  // AppDatabase()
  //     : super(FlutterQueryExecutor.inDatabaseFolder(
  //           path: 'db.sqlite', logStatements: true));
  // Database(QueryExecutor e) : super(e);
  AppDatabase(QueryExecutor e): super(e);

  @override
  int get schemaVersion => 7;
  //cart

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await m.createAll();
      }
  );
}



  //
  // Stream<List<NotificationModelData>> getUnReadNotifications() {
  //   final query = select(notificationModel)
  //     ..where((tbl) => tbl.isRead.equals(false));
  //
  //   return query.watch();
  //
  //   // return (select(notificationModel)..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])).watch();
  // }

  // Stream<List<NotificationModelData>> getAlNotification() {
  //   return (select(notificationModel)
  //         ..orderBy(
  //             [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
  //       .watch();
  //
  //   // return (select(notificationModel)..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])).watch();
  // }

  //notification
  // Future<List<NotificationModelData>> getAllNotificationData() {
  //   return (select(notificationModel)
  //         ..orderBy(
  //             [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
  //       .get();
  //
  //   // select(notificationModel).get()
  // }

  // Add user
  // Future insertNotificationData(NotificationModelData model) =>
  //     into(notificationModel).insert(model);

  // Update user
  // Future updateNotificationData(NotificationModelData model) =>
  //     update(notificationModel).replace(model);
  //
  // // Delete user
  // Future deleteNotificationData(NotificationModelData model) =>
  //     delete(notificationModel).delete(model);
  //
  // Future deleteAllNotificationData() => delete(notificationModel).go();

// Future updateNotificationData(Insertable<NotificationModelData> model) => update(notificationModel).replace(model);

  // Future readNotification(){
  //
  //   return customUpdate('UPDATE notification_model SET is_read = TRUE');
  //
  // }


