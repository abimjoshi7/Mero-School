import 'package:drift/drift.dart';

class NotificationModel extends Table {
  TextColumn get id => text()();

  TextColumn get courseId => text()();

  TextColumn get icon => text()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  TextColumn get type => text()();

  TextColumn get notifyTime => text()();

  BoolColumn get isRead => boolean()();

  // @override
  Set<Column> get primaryKey => {title, description};
}
