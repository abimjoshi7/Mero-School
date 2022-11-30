import 'package:entrance/ui/package/package_list.dart';
import 'package:entrance/ui/widgets/syllabus_widget.dart';
import 'package:entrance/ui/utils/VerticalSpace.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'package/mock_test_list.dart';

class EntranceCourseDetails extends StatefulWidget {
  const EntranceCourseDetails({Key? key}) : super(key: key);

  @override
  _EntranceCourseDetailsState createState() => _EntranceCourseDetailsState();
}

class _EntranceCourseDetailsState extends State<EntranceCourseDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            VSpace(),
            Text(
              "Engineering \nPhysics Preparation",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            VSpace(),
            Text(
              "1000 Hours, 120 Sets, 50 free Mock Test",
            ),
            VSpace(),
            VSpace(),
            VSpace(),
            VSpace(),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Package",
                ),
                Tab(text: "Syllabus"),
                Tab(text: "Mock Test"),
              ],
              isScrollable: false,
              indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(25.0)),
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: [PackageList(), SyllabusWidget(), MockTestsList()]),
            )
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
