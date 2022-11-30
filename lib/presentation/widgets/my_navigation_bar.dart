import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/extension_utils.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key, required this.onItemTapped})
      : super(key: key);

  final Function(int index) onItemTapped;

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.onItemTapped(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(ic_course)), label: course),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(ic_my_course)), label: my_course),
          BottomNavigationBarItem(
              icon: Icon(Icons.backpack),
              label: "Plans"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(
                ic_account,
              )),
              label: account),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_vert_rounded), label: more)
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedIconTheme: IconThemeData(
            color: HexColor.fromHex(bottomNavigationEnabledState)),
        unselectedIconTheme:
            IconThemeData(color: HexColor.fromHex(bottomNavigationIdealState)),
        selectedItemColor: HexColor.fromHex(bottomNavigationEnabledState),
        unselectedItemColor: HexColor.fromHex(bottomNavigationIdealState),
        iconSize: 20,
        onTap: _onTabTapped,
        elevation: 5);
  }
}
