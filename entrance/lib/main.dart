import 'dart:io';

import 'package:entrance/ui/entrance_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bloc/sub_category_model_bloc.dart';

const Color primaryColor = Colors.blueAccent;
const Color secondaryColor = Colors.lightGreen;

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(providers: [
    Provider(create: (context) => SubCategoryModelBloc()),
  ], child: MyApp()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: EntranceHome(title: "Mero School's Entrance"),
      // home: EntrancePlayPage(),
      // home: EntranceCourseDetails(),
      // home: CategoryPack()
    );
  }
}
