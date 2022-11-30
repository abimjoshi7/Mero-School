//#region
import 'package:flutter/material.dart';
import 'package:mero_school/data/models/response/section_response.dart';
import 'package:mero_school/prepare_lesson.dart';
import 'package:mero_school/presentation/constants/app_values';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/widgets/lessonsWidget.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/webengage/TagMeta.dart';

import 'data/models/response/course_details_by_id_response.dart';
import 'expandable.dart';

//#endregion
// ignore: must_be_immutable
class ExpansionTilePlayer extends StatelessWidget {
  Lessons? lessons;
  List<Data>? sectionList;
  Function(String?, Lessons?) callback;
  Function(double percent)? percentCallback;
  Function(int, int)? percentUpdate;
  String? courseName;

  TagMeta? _tagMeta;

  String? _action;
  String? _data;
  List<Entry> changedData = <Entry>[];

  @override
  Widget build(BuildContext context) {
    // print("Size" + sectionList.length.toString());

    sectionList?.forEach((element) {
      PrepareLesson prepareLesson = PrepareLesson();
      Entry entry = Entry(
          element.title, prepareLesson.refactorToNested(element.lessons!));
      entry.isSection = true;
      entry.count = element.lessons!.length.toString();
      entry.duration = element.totalDuration.toString();
      entry.tagMeta = _tagMeta;

      changedData.add(entry);
    });

    // changedData = data;

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: changedData.length,
      itemBuilder: (BuildContext context, int index) => EntryItemPlayer(
          changedData[index],
          callback,
          _data,
          _action,
          percentCallback,
          percentUpdate,
          lessons,
          courseName),
    );
  }

  ExpansionTilePlayer(this.sectionList, this.callback, this._data, this._action,
      this._tagMeta, this.percentCallback, this.percentUpdate,
      [this.courseName]);
}

// Create the Widget for the row
class EntryItemPlayer extends StatelessWidget {
  EntryItemPlayer(this.entry, this.callback, this.data, this.action,
      this.percentCallback, this.percentUpdate,
      [this.lesson, this.courseName]);

  Function(double percent)? percentCallback;

  Function(int, int)? percentUpdate;
  void backFromLesson(bool ack, double percent) {
    percentCallback!.call(percent);
    //send back
  }

  final Entry entry;
  Function(String?, Lessons?) callback;
  String? data;
  String? action;

  BuildContext? _context;
  Lessons? lesson;
  String? courseName;

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(Entry? root) {
    Icon icon = Icon(
      Icons.lock,
      size: 14,
      color: Colors.grey,
      // color: Colors.red.shade900,
    );
    bool isPremium = true;
    bool isLocked = false;
    Widget subline = Column();
    List<String?> isSectionLessonFreeList =
        root!.children!.map((e) => e!.lessons!.isLessonFree).toList();

    if (root.isSection == false) {
      if (root.lessons!.isLessonFree == "1") {
        isPremium = false;
      }
      if (root.lessons!.isLessonFree == "0" ||
          root.lessons!.isLessonFree == null) {
        isLocked = true;
      }
    }

    if (root.isSection == true) {
      if (isSectionLessonFreeList.every((element) => element == "1"))
        isPremium = false;
      if (isSectionLessonFreeList.every(
          (element) => element == null || element == "0")) isLocked = true;

      subline = Column(
        children: [
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${root.count} Lessons | " + root.duration,
                style: TextStyle(
                    fontSize: 13,
                    color: HexColor.fromHex(bottomNavigationIdealState)),
              ),
            ],
          ),
        ],
      );
    } else {
      subline = Column();
    }

    if (root.children!.isEmpty) {
      var isFree = "";

      if (root.lessons!.isLessonFree == "1") {
        isFree = "Free ";
      }

      if (root.lessons!.isCompleted.toString() == "1") {
        root.lessons!.isChecked = true;
      } else {
        root.lessons!.isChecked = false;
      }

      int? level = 0;
      if (root.level != null) {
        level = root.level;
      }

      return ListTile(
        title: InkWell(
          onTap: () {
            handleClickAction(root.lessons, data, _context, action);
          },
          child: LessonsWidget(
            lesson: root.lessons,
            callback: backFromLesson,
            level: level,
            title: root.title,
            percentUpdate: percentUpdate,
          ),
        ),
      );
    }

    int? level = 0;
    if (root.level != null) {
      level = root.level;
    }

    return ExpansionTile(
      key: PageStorageKey<Entry?>(root),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: intend * level!,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        root.title!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black87),
                        softWrap: true,
                      ),
                    ),
                    // ElevatedButton(
                    //     child: Text("!"),
                    //     onPressed: () {
                    //       print(courseName);
                    //     }),
                    courseName!.contains("Class") == true
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child:
                                    isLocked == true ? icon : SizedBox.shrink(),
                              ),
                              isPremium == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        "Free",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: HexColor.fromHex(
                                                colorPrimaryDark)),
                                        softWrap: true,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
          subline
        ],
      ),
      children: root.children!.map<Widget>(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Card(child: _buildTiles(entry));
  }

  handleClickAction(
      Lessons? lessons, String? data, BuildContext? context, String? action) {
    callback(data, lessons);

    // bool isPlay = false;
    // if (lessons.isLessonFree == "1") {
    //   isPlay = true;
    // } else {
    //   // switch (data.action.toLowerCase()) {
    //   //   case STR_BUY_NOW:
    //   //     callback(STR_BUY_NOW, lessons);
    //   //     break;
    //   //   case STR_ENROLL:
    //   //     callback(STR_ENROLL, lessons);
    //   //     break;
    //   //   default:
    //   //     isPlay = true;
    //   // }
    //
    //   // }
    // }
  }
}
