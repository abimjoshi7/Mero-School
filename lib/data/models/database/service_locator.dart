import 'package:get_it/get_it.dart';
import 'package:mero_school/app_database.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerSingleton<AppDatabase>(AppDatabase.instance);
}
