import 'package:entrance/bloc/category_model_bloc.dart';
import 'package:entrance/ui/category_sub_category_widget.dart';
import 'package:flutter/material.dart';

class EntranceHome extends StatefulWidget {
  final String title;
  const EntranceHome({Key? key, required this.title}) : super(key: key);

  @override
  _EntranceHomeState createState() => _EntranceHomeState();
}

class _EntranceHomeState extends State<EntranceHome> {
  late CategoryModelBloc _bloc;

  @override
  void initState() {
    _bloc = CategoryModelBloc();
    super.initState();
  }

  List<Widget> pages = [
    CategoryPack(),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.yellow,
    ),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.title}"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: "Category"),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart), label: "History")
          ],
        ),
        body: Container(
          child: pages.elementAt(currentIndex),
        ));
  }
}
