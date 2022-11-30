

import 'package:drift/drift.dart';

class MyCartModel extends Table {
  TextColumn get cartId => text()();

  TextColumn get title => text()();

  TextColumn get shortDescription => text()();
  TextColumn get level => text()();

  TextColumn get price => text()();

  TextColumn get appleProductId => text()();

  TextColumn get tagsmeta => text()();

  @override
  Set<Column> get primaryKey => {cartId};


}
