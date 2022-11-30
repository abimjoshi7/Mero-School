
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/business_login/blocs/all_plans_bloc.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/data/models/response/plan_category_response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/custom_image_dialog.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical_fixed.dart';
import 'package:mero_school/presentation/widgets/search/all_course_search.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/utils/image_error.dart';
import 'package:mero_school/utils/plan_filter_button_sheet.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../../../main.dart';

class AllPlansPage extends StatefulWidget {
  final argument;

  bool isBottomSheet = false;

  AllPlansPage({this.argument, required this.isBottomSheet});

  @override
  _AllPlansPageState createState() => _AllPlansPageState();
}

class _AllPlansPageState extends State<AllPlansPage> {
  late AllPlansBloc _allPlansBloc;
  ScrollController? _controller;
  // int offset = 0;

  @override
  void initState() {
    _controller = ScrollController();
    _controller!.addListener(_scrollListener);

    // _allPlansBloc = AllPlansBloc();

    super.initState();

    WebEngagePlugin.trackScreen(TAG_PAGE_ALL_PLAN);
    WebEngagePlugin.trackEvent(TAG_ALL_PLAN_CLICKED, {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _scrollListener() {
    if (_controller!.position.pixels == _controller!.position.maxScrollExtent) {
      // offset = offset + 1;
      _allPlansBloc.fetchAllPlansFilter();
    }
  }

  void goBackOrOpenHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  Future<String?> getToken() async {
    return await Preference.getString(user_id);
  }

  String previousId = "";

  @override
  Widget build(BuildContext context) {
    _allPlansBloc = Provider.of<AllPlansBloc>(context);
    _allPlansBloc.initBloc();

    if (widget.argument != null) {
      final Map? arguments = widget.argument as Map?;

      if (arguments != null && arguments['id'] != null) {
        print("id: " + arguments['id']);
        _allPlansBloc.fetchAllPlansFilter(
            offset: "0", planId: "${arguments['id']}", packageId: "all");
      } else {
        _allPlansBloc.fetchAllPlansFilter(
            offset: "0", planId: "all", packageId: "all");
      }
      print("Argument is not null;::");
    } else {
      _allPlansBloc.fetchAllPlansFilter(
          offset: "0", planId: "all", packageId: "all");
    }

    return FutureBuilder<String?>(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          String tokenData = Common.checkNullOrNot(snapshot.data);

          bool isLogin = false;

          if (tokenData.isNotEmpty) {
            isLogin = true;
          }

          return Scaffold(
            appBar: !widget.isBottomSheet
                ? AllCourseSearch(
                    isAllCourse: true,
                    isPlan: true,
                    callback: (searchQuery) {
                      analytics
                          .logEvent(name: SEARCH, parameters: <String, String>{
                        SEARCH_TERM: searchQuery,
                      });

                      debugPrint("test new $searchQuery");
                      _allPlansBloc.searchPlan(searchQuery);

                      // Navigator.pushNamed(context, all_course,
                      //     arguments: <String, String>{'search_string': searchQuery});
                    },
                    back: () {
                      // Navigator.of(context).pop();

                      goBackOrOpenHome();
                    },
                  )
                : null,
            body: StreamBuilder<List<AppPlanData>>(
                stream: _allPlansBloc.allPlansDataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: PlaceHolderLoadingVerticalFixed());
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder<String>(
                                    builder: (context, countSnap) {
                                      print("--count: ${countSnap.data}");

                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "Showing ${snapshot.data!.length}/${countSnap.data} Plans ",
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  colorDarkRed),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    },
                                    stream: _allPlansBloc.countDataStream,
                                  ),
                                  Visibility(
                                    visible: isLogin,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, my_plan_history_page);
                                      },
                                      child: Container(
                                          child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "My Plans",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: HexColor.fromHex(
                                                      colorBlue)),
                                            ),
                                            Icon(
                                              AntDesign.doubleright,
                                              size: 12,
                                              color:
                                                  HexColor.fromHex(colorBlue),
                                            )
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  controller: _controller,
                                  itemCount: snapshot.data!.length,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return loadSingleItemCard(
                                        snapshot.data![index]);
                                  }),
                            ),
                          ],
                        );
                      } else {
                        return Error(
                          errorMessage: "Record not found",
                          isDisplayButton: false,
                          onRetryPressed: () =>
                              _allPlansBloc.fetchAllPlansFilter(),
                        );
                      }

                      // switch (snapshot.data.status) {
                      //   case Status.LOADING:
                      //     return Loading(loadingMessage: snapshot.data.message);
                      //     break;
                      //   case Status.COMPLETED:
                      //     var myList = snapshot.data.data.data;
                      //     break;
                      //   case Status.ERROR:
                      //     return Error(
                      //       errorMessage: snapshot.data.message,
                      //       onRetryPressed: () => _allPlansBloc.fetchAllPlans(offset.toString()),
                      //     );
                      //     break;
                      // }
                    } else {
                      return Loading(loadingMessage: "No Record found");
                    }
                  }
                }),
            floatingActionButton: FloatingActionButton.extended(
              extendedPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              onPressed: () {
                showPopUp();
              },

              //   icon: Image.asset(
              //   ic_filter,
              //   height: 24,
              //   width: 24,
              // ),

              label: Row(
                children: [
                  Icon(Icons.filter_alt_outlined, size: 18),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Filter Plan"),
                ],
              ),
            ),
          );
        });
  }

  void showPopUp() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (dialogContext) {
          return Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0))),
            child: PlanFliterMethod(
                systemSettingsResponse: null,
                callback: (CategoryData? plan, CategoryData? package) {
                  WebEngagePlugin.trackEvent(TAG_PLAN_FILTER, {
                    'Package': "${package?.label}",
                    'Package Id': "${package?.id}",
                    'Plan Name': "${plan?.label}",
                    'Plan Id': "${plan?.id}",
                  });

                  print("sleected::  ${plan?.label} ${package?.label}");
                  _allPlansBloc.fetchAllPlansFilter(
                      offset: "0",
                      planId: "${plan?.id}",
                      packageId: "${package?.id}");
                  // Navigator.pop(dialogContext);
                }),
          );
        });
  }

  Widget loadSingleItemCard(AppPlanData model) {
    // var model = data.data.data[index];
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, plans_details_page,
            arguments: <String, AppPlanData>{'model': model});
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(model.plans!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: HexColor.fromHex(bottomNavigationEnabledState),
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: HexColor.fromHex(bottomNavigationIdealState),
                      thickness: 0.2,
                      height: 0.1,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            var dialog = CustomImageDialog(model.thumbnail);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              },
                            );
                          },
                          child: FadeInImage.assetNetwork(
                              image: model.thumbnail!,
                              height: 120,
                              width: 120,
                              placeholder: logo_placeholder,
                              imageErrorBuilder: (_, __, ___) {
                                return ImageError();
                              },
                              fit: BoxFit.fill),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(model.courseDuration!,
                                    style: TextStyle(
                                        color: HexColor.fromHex(
                                            bottomNavigationEnabledState))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${model.subscription!.length} Subscriptions",
                                    style: TextStyle(
                                        color: HexColor.fromHex(colorAccent))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${model.coursePlan!.length.toString().trim()} Courses",
                                    style: TextStyle(
                                        color: HexColor.fromHex(
                                            bottomNavigationEnabledState))),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: HexColor.fromHex(bottomNavigationIdealState),
                      thickness: 0.2,
                      height: 0.1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                      child: Text(
                          model.shortDescription == null
                              ? empty
                              : model.shortDescription!,
                          maxLines: 2,
                          style: TextStyle(
                              color: HexColor.fromHex(
                                  bottomNavigationEnabledState))),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    _allPlansBloc.dispose();
    super.dispose();
  }
}
