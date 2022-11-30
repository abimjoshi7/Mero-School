import 'dart:developer';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/CurrentPlayingNotifier.dart';
import 'package:mero_school/business_login/blocs/hls_video_player_bloc.dart';
import 'package:mero_school/business_login/blocs/lessons_bloc.dart';
import 'package:mero_school/data/models/custom/section_title_model.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/section_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/buy_alert_dialog.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical.dart';
import 'package:mero_school/presentation/widgets/message_alert_dialog.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/TagMeta.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../../business_login/blocs/course_details_bloc.dart';
import '../../../data/models/response/certificate_status_response.dart';
import '../../../expandable_player.dart';
import '../../../utils/app_progress_dialog.dart';
import '../pdf_viewer_page.dart';

String courseName = "";

// ignore: must_be_immutable
class HLSPlayListPlayerPage extends StatelessWidget {
  late Map _arguments;

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return Container(
      child: HLSPlayListPlayer(_arguments),
    );
  }
}

// ignore: must_be_immutable
class HLSPlayListPlayer extends StatefulWidget {
  Map _arguments;

  HLSPlayListPlayer(this._arguments);

  @override
  _HLSPlayListPlayerState createState() => _HLSPlayListPlayerState(_arguments);
}

class _HLSPlayListPlayerState extends State<HLSPlayListPlayer> {
  Map _arguments;
  late HLSVideoPlayerBloc _hlsVideoPlayerBloc;

  _HLSPlayListPlayerState(this._arguments);

  final GlobalKey<BetterPlayerPlaylistState> _betterPlayerPlaylistStateKey =
      GlobalKey();
  List<BetterPlayerDataSource> _dataSourceList = [];

  var posMap = Map<String?, int>();
  var titleMap = Map<int, String?>();
  var chapterMap = Map<int, String?>();
  var urlMap = Map<int, String?>();
  var freeMap = Map<int, String?>();
  var lesDuration = Map<int, String?>();

  late BetterPlayerConfiguration _betterPlayerConfiguration;
  BetterPlayerPlaylistConfiguration? _betterPlayerPlaylistConfiguration;

  BetterPlayerController? _betterPlayerController;
  late LessonsBloc _lessonsBloc;
  String? encodedToken;
  late CourseDetailsBloc _courseDetailsBloc;

  int? totalCourse;
  String? videoUrl;
  int? markedLesson;

  TagMeta tag = TagMeta();

  String selected_title = "";
  String lesson_id = "";

  @override
  void dispose() {
    _hlsVideoPlayerBloc.dispose();
    _betterPlayerController!.dispose(forceDispose: true);
    // _betterPlayerController.removeEventsListener(onPlayerEvent);
    // _betterPlayerPlaylistController.betterPlayerController.removeEventsListener(onPlayerEvent);

    super.dispose();
  }

  String chapter_name = "";
  String video_name = "";

  String? les_duration = "";

  String? course_id = "";
  String? action = "";
  bool courseCompleted = false;

  initTagData() {
    tag = TagMeta();

    //print("===arguments 1 ${_arguments['tags']}");
    tag.getDefault(_arguments);
    course_id = _arguments['course_id'];
    action = _arguments['action'];
    les_duration = _arguments['les_duration'];

    print("les_duration:  $les_duration");
  }

  int currentIndex = 0;

  displayPurchase() {
    //print("===arguments 2 ${_arguments['tags']}");

    VoidCallback continueCallBack = () {
      var myCartModel = MyCartModelData(
          cartId: _arguments['course_id'],
          title: _arguments['title'],
          shortDescription: _arguments['shortDescription'],
          level: _arguments['level'],
          price: _arguments['price'],
          appleProductId: '${_arguments['appleProductId']}',
          tagsmeta: _arguments['tags']);
      _hlsVideoPlayerBloc.insertDataIntoDatabase(myCartModel);

      Navigator.pushNamed(context, my_carts).then((value) {
        //goback and fetch
        //print("retrunback: in hslplaylist $value");
        Navigator.of(context).pop(value);
      });
    };
    var dialog = BuyAlertDialog(
        "Sorry, this video is not free,would you like to add to cart?",
        continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  @override
  void initState() {
    _hlsVideoPlayerBloc = HLSVideoPlayerBloc();

    videoUrl = _arguments['video_url'];

    initTagData();

    //remove this
    // videoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

    //print("videoRul $videoUrl");
    _hlsVideoPlayerBloc.initBloc(videoUrl);
    _hlsVideoPlayerBloc.setCompletion(false);
    _lessonsBloc = LessonsBloc();
    _courseDetailsBloc = CourseDetailsBloc();
    _courseDetailsBloc.initBloc();
    _lessonsBloc.initBloc();
    _courseDetailsBloc.checkCertificate(course_id);
    _courseDetailsBloc.fetchCourseDetailsById(course_id);

    // if (videoUrl != null) {
    //   _hlsVideoPlayerBloc.fetchData(videoUrl);
    // }

    _hlsVideoPlayerBloc.fetchSection(_arguments['course_id']);
    encodedToken = _arguments['encoded_token'];

    //print("encodedToken"+ encodedToken);

    betterPlayerInitialized();

    super.initState();

    WebEngagePlugin.trackScreen(TAG_PAGE_VIDEO_PLAYER);
  }

  Future<void> betterPlayerInitialized() async {
    var byPassCacheValue = false;

    var serverValue = await Preference.getString(bypass);

    //Platform.isIOS &&

    if (Platform.isIOS && serverValue == "true") {
      byPassCacheValue = true;
    }

    _betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: true,
        aspectRatio: 16 / 9,
        fit: BoxFit.fill,
        autoDispose: true,
        placeholderOnTop: true,
        showPlaceholderUntilPlay: true,
        looping: false,
        handleLifecycle: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        byPassCache: byPassCacheValue,
        controlsConfiguration: BetterPlayerControlsConfiguration(
            enableMute: true,
            enableProgressText: true,
            enableSkips: true,
            enableQualities: true,
            enableAudioTracks: false,
            enableSubtitles: false,
            controlBarColor: Colors.black26),
        eventListener: (event) async {
          print("EVENT::: ${event.betterPlayerEventType}");

          if (event.betterPlayerEventType ==
              BetterPlayerEventType.initialized) {
            _hlsVideoPlayerBloc.fetchAndLog(
                course_id, videoUrl, TAG_VIDEO_STARTED, 0.0);
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.displayPurchase) {
            displayPurchase();
            // if(_arguments['action'] == STR_BUY_NOW){
            // }
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.alternetPlayer) {
            var videoUrl = event.parameters!["downloadUrl"];

            const platform = const MethodChannel("native_channel");

            var map = {
              "url": "$videoUrl",
              "token": "$encodedToken",
            };

            platform.invokeMethod("alternatePlay", map);
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.downloadClicked) {
            //print("--action $action");
            print("fetch ${event.parameters!["downloadUrl"]}");
            if (action!.toLowerCase() == STR_ENROLLED ||
                action!.toLowerCase() == STR_PURCHASED) {
              var videoUrl = event.parameters!["downloadUrl"];

              const platform = const MethodChannel("native_channel");

              var isDownloaded = await platform.invokeMethod("checkDownload", {
                "url": "$videoUrl",
              });

              if (isDownloaded) {
                var dialog = MessageAlertDialog(
                    "This video already available in your download list. Go to Downloads?",
                    "Show Downloads", () {
                  platform.invokeMethod("startDownloadActivity");
                });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog;
                  },
                );
              } else {
                if (tag.course_expiry_date!.isEmpty) {
                  print("fetch ExpiryDate---");
                  _hlsVideoPlayerBloc.fetchValidCourse();
                }

                var dialog = MessageAlertDialog(
                    "Video added to Queue. Go to Downloads?", "Show Downloads",
                    () {
                  platform.invokeMethod("startDownloadActivity");
                });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog;
                  },
                );

                var videoTitle = video_name;

                if (chapter_name.isNotEmpty && chapter_name != "null") {
                  videoTitle = "$videoTitle [$chapter_name]";
                }

                var map = {
                  "url": "$videoUrl",
                  "token": "$encodedToken",
                  "lession_title": "$videoTitle",
                  "thumbnail": "${_arguments['thumbnail']}",
                  "proxy": "${urlMap[currentIndex]}",
                  "duration": "$les_duration",
                  "course": "$course_id",
                  "course_expiry_date": "${tag.course_expiry_date}",
                  "course_title": "${tag.course_name}"
                };

                //print("Maps ${map.toString()}");

                platform.invokeMethod("startDownload", map);
              }
            } else {
              var dialog = MessageAlertDialog(
                  "Your are not enrolled in this course. In order to download offline you need to either enroll or purchase this course.",
                  "Okay",
                  () {});

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return dialog;
                },
              );
            }
            //print("enrollmnet ${tag.enrollement}");

          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.updateLabel) {
            var currentIndex = event.parameters!["nextIndex"];
            //working
            updateLabelDetails(currentIndex);
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.finished) {
            // _lessonsBloc.saveCourseProgress(lesson_id, "1").then((response){
            //   _hlsVideoPlayerBloc.fetchSection(course_id);

            // var total = response.numberOfLessons!;
            // var complete = response.numberOfCompletedLessons!;

            // double result = (complete.toDouble() / total.toDouble()) *100;
            // percentUpdate(total, complete);
            // percentCallback(result);

            // print(" VIDEO COMPLETED ${response.courseId} ${response.courseProgress} ${response.numberOfCompletedLessons}");
            // });

            // _lessonsBloc.saveCourseProgress(lessonId, "");
            WebEngagePlugin.trackEvent(TAG_VIDEO_COMPLETED, {
              'Course Id': int.parse(tag.course_id ?? "0"),
              'Video Name': "$video_name",
              'Chapter Name': "$chapter_name",
              'Category Id': tag.category_id != null
                  ? int.tryParse(tag.category_id ?? "0")
                  : 0,
              'Course Name': "${tag.course_name}",
              'Category Name': "${tag.category_name}",
              'Video Duration': "${tag.course_time_duration}",
            });
          }
        });

    _betterPlayerPlaylistConfiguration = BetterPlayerPlaylistConfiguration(
      loopVideos: false,
      nextVideoDelay: Duration(seconds: 1),
      initialStartIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Container(child: videoLoader())),
            SizedBox(
              height: 8,
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  StreamBuilder<SectionTitle>(
                      stream: _hlsVideoPlayerBloc.dataStreamTitle,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          courseName = snapshot.data!.subTitle.toString();
                          var select = false;

                          if (snapshot.data!.title.toString() ==
                              snapshot.data!.subTitle.toString()) {
                            select = true;
                          }

                          var marked = snapshot.data!.markedLesson.toDouble();
                          var total = snapshot.data!.totalLesson.toDouble();

                          //send tag:::
                          // Video Name
                          // Chapter Name
                          // Category Name
                          // Category Id
                          // Course Name
                          // Course Id
                          // Video Duration

                          video_name = (null != snapshot.data!.title.toString())
                              ? snapshot.data!.title.toString()
                              : "";
                          chapter_name =
                              (null != snapshot.data!.chapter.toString())
                                  ? snapshot.data!.chapter.toString()
                                  : "";
                          les_duration =
                              (null != snapshot.data!.lessDuration.toString())
                                  ? snapshot.data!.lessDuration.toString()
                                  : "";

                          // _hlsVideoPlayerBloc.log(tag.course_id, chapter_name, video_name,.les_duration);

                          //   'action': STR_ENROLLED,
                          //                               'video_url': myLesson.videoUrl,
                          //                               'encoded_token': model.encodedToken,
                          //                               'lessons_title': myLesson.title,
                          //                               'title': model.title,
                          //                               'course_id': myLesson.courseId,
                          //                               'price': model.price,
                          //                               'shareableLink': model.shareableLink,
                          //                               'thumbnail': model.thumbnail,
                          //                               'enrollment': model.totalEnrollment.toString(),
                          //                               'shortDescription': model.shortDescription,
                          //                               'level': model.level,
                          //                               'appleProductId':model.appleProductId,
                          //                               'category_id': model.categoryId,
                          //                               'category_name':model.categoryName,
                          //                               'video_duration': model.hoursLesson

                          var progress = 0.0;

                          progress = (marked / total);

                          //print("== ${snapshot.data.markedLesson}   ${snapshot.data.totalLesson}");

                          if (snapshot.data!.totalLesson == 0 ||
                              snapshot.data!.markedLesson == 0) {
                            progress = 0.001;
                          }

                          //print("Progress: $progress  totla: $total marked: $marked");

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 0.0, 8, 0),
                                child: Text(
                                  select
                                      ? "[SELECT VIDEO LESSON]"
                                      : snapshot.data!.title
                                          .toString()
                                          .toUpperCase(),
                                  style: TextStyle(
                                    color: select
                                        ? HexColor.fromHex(colorAccent)
                                        : HexColor.fromHex(
                                            bottomNavigationIdealState),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 4.0, 8, 0),
                                    child: Text(
                                        snapshot.data!.subTitle
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: HexColor.fromHex(darkNavyBlue),
                                          fontSize: 16,
                                        )),
                                  ),
                                  Spacer(),
                                  StreamBuilder<Response<dynamic>>(
                                      stream: _courseDetailsBloc.certStream,
                                      builder: (context, snapshot) {
                                        print(
                                            "THIISSPARTA ${snapshot.data.runtimeType}");
                                        if (snapshot.hasData) {
                                          Response<dynamic>? data =
                                              snapshot.data != null
                                                  ? snapshot.data
                                                      as Response<dynamic>
                                                  : null;
                                          CertificateStatusResponse?
                                              certificateStatusResponse;
                                          try {
                                            certificateStatusResponse = data !=
                                                    null
                                                ? data.data != null
                                                    ? data.data
                                                        as CertificateStatusResponse
                                                    : null
                                                : null;
                                            log("${certificateStatusResponse!.certificateStatus.toString()}");
                                            if (certificateStatusResponse
                                                    .certificateStatus !=
                                                null) {
                                              return Visibility(
                                                visible:
                                                    certificateStatusResponse
                                                            .certificateStatus ??
                                                        false,
                                                child: InkWell(
                                                  onTap: viewCertificate,
                                                  child: Container(
                                                    height: 40,
                                                    width: 160,
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(FontAwesome5
                                                              .file_pdf),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                              "View Certificate")
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          } catch (e) {
                                            return Container();
                                          }
                                        } else {
                                          return Container();
                                        }
                                      }),
                                  SizedBox(
                                    width: 16,
                                  )
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //
                              //
                              //     InkWell(
                              //       child: Padding(
                              //
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Text("Try Alternate"),
                              //       ),
                              //
                              //       onTap: (){
                              //
                              //
                              //         print("alternate try");
                              //       },
                              //     )
                              //   ],
                              // ),

                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      child: LinearProgressIndicator(
                                        backgroundColor: HexColor.fromHex(
                                            bottomNavigationIdealState),
                                        valueColor: new AlwaysStoppedAnimation<
                                                Color>(
                                            HexColor.fromHex(
                                                bottomNavigationEnabledState)),
                                        value: progress,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _betterPlayerPlaylistController!
                                                  .betterPlayerController!
                                                  .pause();

                                              // _betterPlayerController.pause();

                                              createShareableLink(
                                                  _arguments['shareableLink'],
                                                  _arguments['title'],
                                                  _arguments['thumbnail']);
                                            },
                                            icon: Icon(Icons.share),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _betterPlayerPlaylistController!
                                                  .betterPlayerController!
                                                  .pause();
                                              // _betterPlayerController.pause();

                                              Navigator.of(context).pushNamed(
                                                  course_details,
                                                  arguments: <String, String?>{
                                                    'course_id':
                                                        _arguments['course_id'],
                                                    'title':
                                                        _arguments['title'],
                                                    'price':
                                                        _arguments['price'],
                                                    'shareableLink': _arguments[
                                                        'shareableLink'],
                                                    'thumbnail':
                                                        _arguments['thumbnail'],
                                                    'enrollment': _arguments[
                                                        'enrollment'],
                                                    'video_url': videoUrl,
                                                    'fromVideo': "true"
                                                  });
                                            },
                                            icon: Icon(Icons.info),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // PopupMenuButton<String>(
                                    //     onSelected: (String item) {
                                    //   switch (item) {
                                    //     case "Details":
                                    //       {
                                    //         _betterPlayerPlaylistController!
                                    //             .betterPlayerController!
                                    //             .pause();
                                    //         // _betterPlayerController.pause();

                                    //         Navigator.of(context).pushNamed(
                                    //             course_details,
                                    //             arguments: <String, String?>{
                                    //               'course_id':
                                    //                   _arguments['course_id'],
                                    //               'title': _arguments['title'],
                                    //               'price': _arguments['price'],
                                    //               'shareableLink': _arguments[
                                    //                   'shareableLink'],
                                    //               'thumbnail':
                                    //                   _arguments['thumbnail'],
                                    //               'enrollment':
                                    //                   _arguments['enrollment'],
                                    //               'video_url': videoUrl,
                                    //               'fromVideo': "true"
                                    //             });

                                    //         break;
                                    //       }
                                    //     case "Share":
                                    //       {
                                    //         _betterPlayerPlaylistController!
                                    //             .betterPlayerController!
                                    //             .pause();

                                    //         // _betterPlayerController.pause();

                                    //         createShareableLink(
                                    //             _arguments['shareableLink'],
                                    //             _arguments['title'],
                                    //             _arguments['thumbnail']);

                                    //         break;
                                    //       }

                                    //     case "Download":
                                    //       {
                                    //         const platform =
                                    //             const MethodChannel(
                                    //                 "native_channel");
                                    //         platform.invokeMethod(
                                    //             "startDownloadActivity");
                                    //       }
                                    //       break;
                                    //   }
                                    // }, itemBuilder: (BuildContext context) {
                                    //   return [
                                    //     PopupMenuItem(
                                    //         value: "Details",
                                    //         child: Text("Details")),
                                    //     PopupMenuItem(
                                    //         value: "Share",
                                    //         child: Text("Share")),
                                    //     // PopupMenuItem(
                                    //     //     value: "Download",
                                    //     //     child: Text("Download"))
                                    //   ];
                                    // })
                                  ],
                                ),
                              ),
                              Align(
                                  child: Text(
                                      "${snapshot.data!.markedLesson}/${snapshot.data!.totalLesson} Lessons are completed"))
                            ],
                          );
                        }
                        return Container();
                      }),
                  loadExpandedSectionDesign(courseName)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Data>? myList;

  void viewCertificate() {
    AppProgressDialog _progressDialog = new AppProgressDialog(context);
    _progressDialog.show();
    _courseDetailsBloc.generateCertificate(course_id, context).then((value) {
      _progressDialog.hide();
      _courseDetailsBloc.dataStream.first.then((responseById) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => PdfViewerPage(
                    path: value,
                    name: _arguments['title'] ?? "cert-$course_id",
                    arguments: {
                      'Category Id':
                          int.parse(responseById.data?.categoryId ?? "0"),
                      'Category Name': "${responseById.data?.categoryName}",
                      'Course Duration': "${responseById.data?.hoursLesson}",
                      'Course Id': int.parse(responseById.data?.id ?? "0"),
                      'Course Level': "${responseById.data?.level}",
                      'Language': responseById.data?.language ?? "",
                      'Course Name': responseById.data?.title,
                      'Rating': responseById.data?.rating ?? "",
                      'Certificate Generated Date': "",
                    },
                  )))));

      log("FILE RECEIVED" + value.toString());
    });
  }

  Widget videoLoader() {
    return StreamBuilder<Response<SectionResponse>>(
        stream: _hlsVideoPlayerBloc.dataStreamSection,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return Container(
                    height: 230,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        color: Colors.white,
                      ),
                    ));
                break;
              case Status.COMPLETED:
                encodedToken = snapshot.data!.data!.data![0].encodedToken;
                myList = snapshot.data!.data!.data;
                totalCourse = 0;
                markedLesson = 0;

                var indexToPlay = 0;

                int pos = 0;
                _dataSourceList.clear();

                myList!.forEach((element) {
                  element.lessons!.forEach((videoLesson) {
                    if (videoLesson.videoUrl != null &&
                        videoLesson.videoUrl!.isNotEmpty) {
                      if (videoLesson.videoUrl == videoUrl) {
                        indexToPlay = _dataSourceList.length;
                      }

                      var dataSource = BetterPlayerDataSource(
                        BetterPlayerDataSourceType.network,
                        // snapshot.data.data.videoUrl + video_extension,
                        // "https://video.mero.school/science%2010/0.%20Introduction%20To%20Science%7C1.%20Introduction%20to%20course/master.m3u8",
                        videoLesson.videoUrl!,
                        headers: {"Authorization": encodedToken!.trim()},
                        useAsmsTracks: true,
                      );

                      posMap[videoLesson.videoUrl] = pos;
                      titleMap[pos] = videoLesson.lessonTitle;
                      chapterMap[pos] = element.title;
                      urlMap[pos] = videoLesson.videoUrl;
                      freeMap[pos] = videoLesson.isLessonFree;
                      lesDuration[pos] = videoLesson.duration;

                      _dataSourceList.add(dataSource);
                      pos++;
                    }
                  });
                });

                _betterPlayerPlaylistConfiguration =
                    BetterPlayerPlaylistConfiguration(
                  loopVideos: false,
                  nextVideoDelay: Duration(seconds: 1),
                  initialStartIndex: indexToPlay,
                );

                _betterPlayerController = BetterPlayerController(
                  _betterPlayerConfiguration,
                  betterPlayerPlaylistConfiguration:
                      _betterPlayerPlaylistConfiguration,
                );

                // var dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network,
                //     // snapshot.data.data.videoUrl + video_extension,
                //     videoUrl,
                //     headers: {"Authorization": encodedToken.trim()}
                //     );
                //
                // _betterPlayerController.setupDataSource(dataSource);

                var player = BetterPlayerPlaylist(
                  key: _betterPlayerPlaylistStateKey,
                  betterPlayerConfiguration: _betterPlayerConfiguration,
                  betterPlayerPlaylistConfiguration:
                      _betterPlayerPlaylistConfiguration!,
                  betterPlayerDataSourceList: _dataSourceList,
                );

                return player;

                break;

              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data!.message,
                  onRetryPressed: () =>
                      _hlsVideoPlayerBloc.fetchData(videoUrl!),
                );
                break;
              case Status.SUCCESS:
                // TODO: Handle this case.
                break;
              case Status.LOGOUT:
                // TODO: Handle this case.
                break;
              case Status.COMPLETE_MESSAGE:
                // TODO: Handle this case.
                break;
            }
          }
          return Container(
            color: Colors.black54,
          );
        });
  }

  void percentUpdate(int totalCourse, int markedLesson) {
    log("PercentCompleted $markedLesson $totalCourse");
    _hlsVideoPlayerBloc.fetchUpdateCount(totalCourse, markedLesson);
  }

  void percentCallback(double percent) {
    log("PercentCompleted $percent ");
    _courseDetailsBloc.checkCertificate(course_id);

    if (percent == 100.0) {
      _courseDetailsBloc.certStream.listen((event) {
        if (event != Null) {
          Response<dynamic>? data = event != null ? event : null;
          CertificateStatusResponse? certificateStatusResponse;
          try {
            certificateStatusResponse = data != null
                ? data.data != null
                    ? data.data as CertificateStatusResponse
                    : null
                : null;
            log("${certificateStatusResponse!.certificateStatus.toString()}");
            if (certificateStatusResponse.certificateStatus != null) {
              if (certificateStatusResponse.certificateStatus!) {
                var messageBuilder = MessageAlertDialog(
                    "Congratulations!! You have successfully completed this course.",
                    "View Certificate",
                    viewCertificate);
                showDialog(context: context, builder: (ctx) => messageBuilder);
              }
            }
          } catch (e) {}
        }
        if (event.data) {}
      });
    } else {
      _hlsVideoPlayerBloc.setCompletion(false);
    }
    _hlsVideoPlayerBloc.fetchAndLog(
        course_id, videoUrl, TAG_COURSE_COMPLETION, percent);
  }

  void callback(value, lesson) {
    Lessons lessons = lesson;
    //print("CallBack:  " + value + ":: " + lessons.title);

    bool isPlay = false;

    if (lessons.videoUrl!.isNotEmpty) {
      lesson_id = lessons.id.toString();
      isPlay = true;
    } else {
      switch (_arguments['action'].toString().toLowerCase()) {
        case STR_BUY_NOW:
          VoidCallback continueCallBack = () {
            var myCartModel = MyCartModelData(
                cartId: _arguments['course_id'],
                title: _arguments['title'],
                shortDescription: _arguments['shortDescription'],
                level: _arguments['level'],
                price: _arguments['price'],
                appleProductId: '${_arguments['appleProductId']}',
                tagsmeta: '${_arguments['tags']}');
            _hlsVideoPlayerBloc.insertDataIntoDatabase(myCartModel);
            Navigator.pushNamed(context, my_carts);
          };
          var dialog = BuyAlertDialog(
              "Sorry, this video is not free,would you like to add to cart?",
              continueCallBack);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            },
          );

          break;
        case STR_ENROLL:
          Common.isUserLogin().then((value) {
            if (value) {
              _hlsVideoPlayerBloc
                  .enrolledToFreeCourse(_arguments['course_id'], null)
                  .then((response) {
                _hlsVideoPlayerBloc.fetchSection(_arguments['course_id']);
                _arguments.update('action', (value) => STR_ENROLLED);
                ToastHelper.showShort(response.message!);
                setState(() {
                  isPlay = true;
                });
              });
            } else {
              Navigator.pushNamed(context, login_page,
                  arguments: <String, bool>{'isPreviousPage': true});
            }
          });

          break;
        default:
          isPlay = true;
      }
    }

    if (isPlay) {
      videoUrl = lessons.videoUrl;
      // _hlsVideoPlayerBloc.fetchData(videoUrl);

      //jump video
      int? jumpPos = 0;

      if (posMap.containsKey(videoUrl)) {
        jumpPos = posMap[videoUrl];
      }

      _betterPlayerPlaylistController!.setupDataSource(jumpPos!);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<CurrentPlayingNotifier>(context, listen: false)
            .update(videoUrl!);
      });

      _hlsVideoPlayerBloc.fetchTitle(
          lessons.title,
          _arguments['title'],
          lessons.videoUrl,
          totalCourse,
          markedLesson,
          lessons.sectionTitle,
          lessons.duration);
    }
  }

  Widget loadExpandedSectionDesign(String courseName) {
    // return ExpansionTileDemo(_data.sections, callback, _data);
    return StreamBuilder<Response<SectionResponse>>(
        stream: _hlsVideoPlayerBloc.dataStreamSection,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data?.status) {
              case Status.LOADING:
                return PlaceHolderLoadingVertical();
                break;
              case Status.COMPLETED:
                encodedToken = snapshot.data?.data?.data?[0].encodedToken;
                if (lesson_id.isEmpty) {
                  lesson_id =
                      snapshot.data?.data?.data?[0].lessons![0].id ?? "";
                }

                List<Data>? myList = [];
                myList = snapshot.data?.data?.data;
                totalCourse = 0;
                markedLesson = 0;

                //
                //
                int pos = 0;

                _dataSourceList.clear();

                myList?.forEach((element) {
                  if (les_duration == null || les_duration!.isEmpty) {
                    if (element.lessons![0].duration!.isNotEmpty) {
                      les_duration = element.lessons![0].duration;
                    }
                  }
                  //
                  element.lessons?.forEach((videoLesson) {
                    if (videoLesson.videoUrl != null &&
                        videoLesson.videoUrl!.isNotEmpty) {
                      var dataSource = BetterPlayerDataSource(
                          BetterPlayerDataSourceType.network,
                          // snapshot.data.data.videoUrl + video_extension,
                          videoLesson.videoUrl!,
                          headers: {"Authorization": encodedToken!.trim()},
                          useAsmsTracks: true);
                      // _dataSourceList.add(dataSource);

                      var header = "${dataSource.headers}";
                      print("header::: $header");

                      posMap[videoLesson.videoUrl] = pos;
                      titleMap[pos] = videoLesson.lessonTitle;
                      chapterMap[pos] = element.title;
                      urlMap[pos] = videoLesson.videoUrl;
                      freeMap[pos] = videoLesson.isLessonFree;
                      lesDuration[pos] = videoLesson.duration;

                      _dataSourceList.add(dataSource);
                      pos++;
                    }
                  });
                });
                //

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Provider.of<CurrentPlayingNotifier>(context, listen: false)
                      .update(_arguments['video_url'].toString());
                });

                //
                _hlsVideoPlayerBloc.fetchTitle(
                    _arguments['lessons_title'].toString(),
                    _arguments['title'].toString(),
                    _arguments['video_url'].toString(),
                    totalCourse,
                    markedLesson,
                    _arguments['section_title'].toString(),
                    _arguments['lesson_duration'].toString());

                // return Container(child: Text("Hell"));

                return Expanded(
                    child: ExpansionTilePlayer(
                  myList,
                  callback,
                  encodedToken,
                  _arguments['action'],
                  tag,
                  percentCallback,
                  percentUpdate,
                  courseName,
                ));

                //
                // return StreamBuilder<String>(
                //    stream:  _hlsVideoPlayerBloc.dataStreamUrl,
                //    builder: (context,snapshot){
                //      String url = "";
                //      if(snapshot.hasData)
                //      {
                //          url = snapshot.data;
                //      }
                //
                //     //print("url changed $url");
                //
                //
                //    },
                //
                //  );

                // return

                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data!.message,
                  onRetryPressed: () =>
                      _hlsVideoPlayerBloc.fetchSection(_arguments['course_id']),
                );
                break;
            }
          }
          return Container();
        });
  }

  void createShareableLink(
      String shareableLink, String? description, String thumbnail) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      androidParameters: AndroidParameters(packageName: 'school.mero.lms'),
      iosParameters: IOSParameters(bundleId: 'school.mero.lms'),
      uriPrefix: 'https://share.mero.school',
      link: Uri.parse(shareableLink),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Check the latest course in Mero School',
          description: description,
          imageUrl: Uri.parse(thumbnail)),
      // socialMetaTagParameters:
    );
    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri shortUrl = shortDynamicLink.shortUrl;
    await Share.share(shortUrl.toString());
  }

  BetterPlayerPlaylistController? get _betterPlayerPlaylistController =>
      _betterPlayerPlaylistStateKey
          .currentState!.betterPlayerPlaylistController;

  void updateLabelDetails(currentIndex) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CurrentPlayingNotifier>(context, listen: false)
          .update(urlMap[currentIndex]!);
    });

    _hlsVideoPlayerBloc.fetchTitle(
        titleMap[currentIndex],
        _arguments['title'],
        urlMap[currentIndex],
        totalCourse,
        markedLesson,
        chapterMap[currentIndex],
        lesDuration[currentIndex]);
  }
}
