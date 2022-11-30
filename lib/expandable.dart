import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/prepare_lesson.dart';
import 'package:mero_school/presentation/constants/app_values';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/webengage/TagMeta.dart';

class ExpansionTileDemo extends StatefulWidget {
  bool? isLoading;
  List<Sections>? sectionList;
  Function(String, Lessons)? callback;
  CourseDetailsByIdResponse _data;

  ExpansionTileDemo(
    this.sectionList,
    this.callback,
    this._data,
  );

  @override
  State<ExpansionTileDemo> createState() => _ExpansionTileDemoState();
}

class _ExpansionTileDemoState extends State<ExpansionTileDemo>
    with AutomaticKeepAliveClientMixin<ExpansionTileDemo> {
  List<Entry> changedData = <Entry>[];

  @override
  void initState() {
    super.initState();
    widget.isLoading = true;
    // print("LOAD:" + widget.isLoading.toString());
    // widget.sectionList!.forEach((element) {
    //   print("SECTIONS: " + element.toJson().toString());
    // });
    // // print("SECTIONS" + widget.sectionList.);
    // print("CALLBACK" + widget.callback.toString());
    // print("DATA" + widget._data.toJson().toString());
  }

  Future<List<Entry>> buildData() async {
    await Future(
      () {
        if (widget.sectionList != null) {
          PrepareLesson prepareLesson = PrepareLesson();
          widget.sectionList?.forEach(
            (element) {
              Entry entry = Entry(
                element.title,
                prepareLesson.refactorToNested(element.lessons!),
              );
              entry.isSection = true;
              entry.count = element.lessons!.length.toString();
              entry.duration = element.totalDuration.toString();
              changedData.add(entry);
            },
          );
        }
      },
    ).whenComplete(() => widget.isLoading = false);

    return changedData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Entry>>(
        future: buildData(),
        builder: (_, snapshot) {
          if (widget.isLoading == false) {
            log(widget._data.toJson().toString());
            return ListView.builder(
                itemCount: changedData.length,
                itemBuilder: (_, int index) {
                  return EntryItem(
                      changedData[index], widget.callback, widget._data);
                });
          }
          return Loading();
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class Entry {
  String? mapId = "";
  final String? title;
  bool? isSection = false;
  TagMeta? tagMeta;
  String count = "";
  String duration = "";
  int? level = 0;
  Lessons? lessons;
  List<Entry?>? children = <Entry>[];
  // List<Entry>children = <Entry>[]; // Since this is an expansion list ...children can be another list of entries
  Entry(this.title, this.children,
      [this.mapId, this.isSection, this.lessons, this.level]);

  @override
  String toString() {
    return title! + "" + children!.length.toString();
  }
}

class EntryItem extends StatelessWidget {
  EntryItem(this.entry, this.callback, this.data);

  final Entry entry;
  Function(String, Lessons)? callback;
  CourseDetailsByIdResponse data;

  BuildContext? _context;

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(Entry? root) {
    Icon lockIcon = Icon(
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

    if (root.isSection == true) {
      if (data.categoryName!.contains('Class')) {
        if (isSectionLessonFreeList.every((element) => element == "1"))
          isPremium = false;
        if (isSectionLessonFreeList.every((element) => element == ""))
          isLocked = true;
      }

      subline = Column(
        children: [
          SizedBox(height: 4.0),
          Row(
            children: [
              Text(
                "${root.count} Lessons | " + root.duration,
                style: TextStyle(
                    fontSize: 13,
                    color: HexColor.fromHex(bottomNavigationIdealState)),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      );
    } else {
      subline = Column();
    }

    if (root.isSection! != true) {}

    if (root.children!.isEmpty) {
      var isFree = "";

      if (root.lessons!.isLessonFree == "1") {
        isFree = "Free ";
      }

      int? level = 0;
      if (root.level != null) {
        level = root.level;
      }

      return Card(
        child: ListTile(
          title: InkWell(
            onTap: () {
              // print(root.lessons!.toJson());
              print(data.toJson());

              handleClickAction(root.lessons!, data, _context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: intend * level!,
                    ),
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.play_arrow,
                          size: 24,
                          color: HexColor.fromHex(colorBlue),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            root.title!,
                            softWrap: true,
                            style: TextStyle(
                                color: HexColor.fromHex(darkNavyBlue),
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                root.lessons!.isLessonFree == "1"
                                    ? Text(
                                        isFree,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: HexColor.fromHex(
                                                colorPrimaryDark)),
                                        softWrap: true,
                                      )
                                    : SizedBox(
                                        width: 20,
                                        child: lockIcon,
                                      ),
                                Text(
                                  "" + root.lessons!.duration!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: HexColor.fromHex("#2D4053")),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    int? level = 0;
    if (root.level != null) {
      level = root.level;
    }
    return Column(
      children: [
        ExpansionTile(
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
                  Expanded(
                    flex: 1,
                    child: Text(
                      root.title!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: HexColor.fromHex("#2D4053")),
                    ),
                  ),
                  isPremium == false
                      ? Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text(
                            "Free",
                            style: TextStyle(
                                fontSize: 13,
                                color: HexColor.fromHex(colorPrimaryDark)),
                            softWrap: true,
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: isLocked == true ? lockIcon : SizedBox(),
                  ),
                  if (!root.isSection! &&
                      data.categoryName!.contains("Class") == true)
                    root.lessons!.isLessonFree == '1'
                        ? Text(
                            "Free",
                            style: TextStyle(
                                fontSize: 13,
                                color: HexColor.fromHex(colorPrimaryDark)),
                            softWrap: true,
                          )
                        : SizedBox(),
                  if (!root.isSection! &&
                      data.categoryName!.contains("Class") == true)
                    root.lessons!.isLessonFree == "" ? lockIcon : SizedBox(),
                ],
              ),
              subline
            ],
          ),
          children: root.children!.map<Widget>(_buildTiles).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Card(child: _buildTiles(entry));
  }

  // * Lesson click
  handleClickAction(
      Lessons lessons, CourseDetailsByIdResponse data, BuildContext? context) {
    bool isPlay = false;
    if (lessons.isLessonFree == "1") {
      isPlay = true;
    } else {
      switch (data.action!.toLowerCase()) {
        case STR_BUY_NOW:
          callback!(STR_BUY_NOW, lessons);
          break;
        case STR_ENROLL:
          callback!(STR_ENROLL, lessons);
          break;
        default:
          isPlay = true;
      }
    }
    // * Login Check
    Common.isUserLogin().then((value) {
      if (value) {
        if (isPlay) {
          var maps = <String, String?>{
            'action': data.action,
            'video_url': lessons.videoUrl,
            'encoded_token': data.encodedToken,
            'lessons_title': lessons.title,
            'title': data.title,
            'course_id': lessons.courseId,
            'price': data.price,
            'shareableLink': data.shareableLink,
            'thumbnail': data.thumbnail,
            'enrollment': data.totalEnrollment.toString(),
            'shortDescription': data.shortDescription,
            'level': data.level,
            'appleProductId': data.appleProductId,
            'category_id':
                data.categoryId == null ? 0 as String? : data.categoryId,
            'category_name': data.categoryName,
            'video_duration': data.hoursLesson,
            'section_title': lessons.sectionTitle,
            'course_expiry_date': data.expDate,
            'les_duration': lessons.duration,
            'tags': json.encode(data.toJson()),
          };
          // print("maps: $maps");
          Navigator.of(context!).pushNamed(video_player, arguments: maps);
        }
      } else {
        Navigator.pushNamed(context!, login_page,
            arguments: <String, bool>{'isPreviousPage': true});
      }
    });
  }
}
