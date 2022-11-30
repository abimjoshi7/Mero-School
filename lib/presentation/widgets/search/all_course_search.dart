import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/notification_bloc.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/utils/extension_utils.dart';

// ignore: must_be_immutable
class AllCourseSearch extends StatefulWidget implements PreferredSizeWidget {
  Function(String searchQuery)? callback;
  Function()? back;

  bool? isAllCourse;
  bool? isPlan;

  AllCourseSearch({this.isAllCourse, this.callback, this.isPlan, this.back});

  @override
  _AllCourseSearchState createState() => _AllCourseSearchState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AllCourseSearchState extends State<AllCourseSearch> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  NotificationBloc notificationBloc = NotificationBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAllCourse!) {
      return AppBar(
        backgroundColor: Colors.white,
        leading: _isSearching
            ? const BackButton()
            : IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: HexColor.fromHex(bottomNavigationEnabledState)),
                onPressed: () {
                  widget.back!();
                },
              ),
        title: _isSearching
            ? _buildSearchField()
            : Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(about_us);
                    },
                    child: Image.asset(
                      logo_no_text,
                      height: 38,
                      width: 38,
                    ),
                  ),
                ],
              ),
        actions: _buildActions(),
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        title: _isSearching ? _buildSearchField() : Container(),
        leading: _isSearching
            ? const BackButton()
            : Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(about_us);
                  },
                  child: Image.asset(
                    logo_no_text,
                    height: 38,
                  ),
                ),
              ),
        actions: _buildActions(),
      );
    }
  }

  Widget _buildSearchField() {
    return TextFormField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.isPlan!
              ? "Search for plans ..."
              : "Search for courses ...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black87),
        ),
        style: TextStyle(color: Colors.black87, fontSize: 16.0),
        onChanged: (query) => updateSearchQuery(query),
        onFieldSubmitted: (value) {
          widget.callback!(value);

          _clearSearchQuery();

          setState(() {
            _isSearching = false;
          });
        });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void clickDownloadActivity() {
    print("here--- download activity clicked");
    //call method channel for downloads

    const platform = const MethodChannel("native_channel");
    platform.invokeMethod("startDownloadActivity");
  }

  Widget showDownload() {
    if (Platform.isAndroid) {
      return InkWell(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.download,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
        onTap: clickDownloadActivity,

        // onPressed: _startSearch,
      );
    } else {
      return Container();
    }
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.clear,
            color: HexColor.fromHex(bottomNavigationIdealState),
          ),
          onPressed: () {
            if (_searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }

            setState(() {
              _isSearching = false;
            });

            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      showDownload(),
      InkWell(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                ic_search,
                height: 24,
                color: Colors.black54,
              )

              // child: Icon(
              //   Icons.search_outlined,
              //   color: Colors.grey,
              //   size: 24,
              // ),
              ),
        ),
        onTap: _startSearch,

        // onPressed: _startSearch,
      ),
      Visibility(
        visible: widget.isAllCourse! ? false : true,
        child: Stack(
          children: [
            // StreamBuilder<List<NotificationModelData>>(
            //     stream: notificationBloc.unreadMessage,
            //     builder: (context, projectSnap) {
            //       if (projectSnap.hasData) {
            //         return Visibility(
            //           visible: projectSnap.data == null ||
            //                   projectSnap.data!.length == 0
            //               ? false
            //               : true,
            //           child: Positioned(
            //               left: 25,
            //               top: 25,
            //               child: Container(
            //                 width: 15.0,
            //                 height: 15.0,
            //                 decoration: new BoxDecoration(
            //                   color: HexColor.fromHex(colorBlue),
            //                   shape: BoxShape.circle,
            //                 ),
            //                 child: Align(
            //                   alignment: Alignment.center,
            //                   child: Text(
            //                     projectSnap.data!.length.toString(),
            //                     style: Theme.of(context)
            //                         .textTheme
            //                         .caption!
            //                         .apply(color: Colors.white),
            //                   ),
            //                 ),
            //               )),
            //         );
            //       } else {
            //         return Container();
            //       }
            //     }),
            FutureBuilder<List<NotificationModelData>>(
                future: notificationBloc.getNotificationData(),
                builder: (context, projectSnap) {
                  if (projectSnap.hasData) {
                    return Visibility(
                      visible: projectSnap.data == null ||
                              projectSnap.data!.length == 0
                          ? false
                          : true,
                      child: Positioned(
                          left: 25,
                          top: 25,
                          child: Container(
                            width: 15.0,
                            height: 15.0,
                            decoration: new BoxDecoration(
                              color: HexColor.fromHex(colorBlue),
                              shape: BoxShape.circle,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                projectSnap.data!.length.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(color: Colors.white),
                              ),
                            ),
                          )),
                    );
                  } else {
                    return Container();
                  }
                }),

            // FutureBuilder(
            //     future: notificationBloc.getUnreadNotification(),
            //     builder: (context, projectSnap) {
            //       return Visibility(
            //         visible: projectSnap.data == null || projectSnap.data == 0 ? false : true,
            //         child: Positioned(
            //             left: 25,
            //             top: 25,
            //             child: Container(
            //               width: 15.0,
            //               height: 15.0,
            //               decoration: new BoxDecoration(
            //                 color: HexColor.fromHex(colorBlue),
            //                 shape: BoxShape.circle,
            //               ),
            //               child: Align(
            //                 alignment: Alignment.center,
            //                 child: Text(
            //                   projectSnap.data.toString(),
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .caption
            //                       .apply(color: Colors.white),
            //                 ),
            //               ),
            //             )),
            //       );
            //     }),

            InkWell(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      ic_bell,
                      height: 30,
                      color: Colors.black87,
                    )),
              ),
              onTap: () {
                Navigator.pushNamed(context, notification_page);
              },
            ),
          ],
        ),
      ),
    ];
  }
}
