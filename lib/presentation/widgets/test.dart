import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/widgets/logout_everywhere_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  LogOutEveryWhereDialog? _logOutEveryWhereDialog;
  @override
  Widget build(BuildContext context) {
    //
    // List<Sections> sectionlist =<Sections> [];
    //
    // Lessons lessons = Lessons(title: "A|B|C|4");
    // Lessons lesson2 = Lessons(title: "A|B|9");
    // Lessons lesson3 = Lessons(title: "A|B|C|3");
    // Lessons lesson4 = Lessons(title: "B|A|E");
    // Lessons lesson5 = Lessons(title: "B|A|F");
    // // Lessons lesson2 = Lessons(title: "A|B|C");
    // // Lessons lesson2 = Lessons(title: "A|B|C");
    //
    // List<Lessons> list = <Lessons>[];
    //
    // list.add(lessons);
    // list.add(lesson2);
    // list.add(lesson3);
    // list.add(lesson4);
    // list.add(lesson5);
    // Sections sections = Sections(title: "First Section", lessons:  list);
    // // Sections sectionSecond = Sections(title: "Section Section", lessons:  list);
    //
    // sectionlist.add(sections);
    // sectionlist.add(sectionSecond);

    return MaterialApp(
        title: 'Shimmer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            // body: ExpansionTileDemo(sectionlist, null, null ),
            body: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, entrance_app);
                },
                child: Text("clcik"))));
  }
}
