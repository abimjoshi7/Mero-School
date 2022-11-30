
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mero_school/business_login/blocs/plans_subscription_bloc.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/pages/course/all_plans/default_grabbing.dart';
import 'package:mero_school/presentation/widgets/custom_image_dialog.dart';
import 'package:mero_school/presentation/widgets/loading/mydivider.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class PlansSubscriptionPageV2 extends StatefulWidget {
  @override
  _PlansSubscriptionPageState createState() => _PlansSubscriptionPageState();
}

class _PlansSubscriptionPageState extends State<PlansSubscriptionPageV2>
    with SingleTickerProviderStateMixin {
  late PlansSubscriptionBloc _plansSubscriptionBloc;
  Map? _arguments;
  late AppProgressDialog _progressDialog;
  TabController? _tabController;
  Subscription? _selectedValue;

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    _tabController = new TabController(length: 2, vsync: this);

    _plansSubscriptionBloc = PlansSubscriptionBloc();
    _plansSubscriptionBloc.initBloc();
    _progressDialog = new AppProgressDialog(context);

    super.initState();
  }

  var course;
  var courseId;
  double price = 0.0;

  var kExpandedHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    AppPlanData data = _arguments!['model'];

    if (data.subscription!.isNotEmpty) {
      if (_selectedValue == null) {
        _selectedValue = data.subscription![0];
      }

      if (data.coursePlan!.isNotEmpty) {
        course =
            [for (var element in data.coursePlan!) element.title].join(",");
        courseId = [for (var element in data.coursePlan!) element.id].join(",");
        data.coursePlan!.forEach((element) {
          if (element.price != null && element.price!.isNotEmpty == true) {
            price = price + double.parse(element.price.toString());
          }
        });
      }
    }

    return Scaffold(
      body: SnappingSheet(
        lockOverflowDrag: true,
        snappingPositions: [
          SnappingPosition.factor(
            positionFactor: 0.0,
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.factor(
            snappingCurve: Curves.elasticOut,
            snappingDuration: Duration(milliseconds: 1750),
            positionFactor: 0.3,
          ),
          // SnappingPosition.factor(positionFactor: 0.9),
        ],
        grabbingHeight: 75,
        grabbing: DefaultGrabbing(),
        sheetBelow: SnappingSheetContent(
            // childScrollController: _scrollController,
            draggable: true,
            child: updateCourseDetailsWidget(data)),
        child: CustomScrollView(
          // controller: _scrollController,

          slivers: [
            // viewPagerApi(data),

            SliverAppBar(
              pinned: true,
              backgroundColor: HexColor.fromHex(colorAccent),
              expandedHeight: kExpandedHeight,
              flexibleSpace: FlexibleSpaceBar(
                // titlePadding: EdgeInsets.symmetric(
                //     vertical: 16.0, horizontal: _horizontalTitlePadding),
                stretchModes: <StretchMode>[
                  StretchMode.fadeTitle,
                  StretchMode.blurBackground,
                ],
                title: Text(
                  data.plans!,
                  style: TextStyle(fontSize: 14),
                ),

                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        Colors.black54,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                  child: Container(
                    height: 200,
                    child: Stack(children: [
                      Image.network(
                        data.thumbnail!,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Container(
                            color: Colors.black45,
                            width: 24,
                            height: 24,
                            child: InkWell(
                              child:
                                  Icon(Icons.fullscreen, color: Colors.white),
                              onTap: () {
                                var dialog = CustomImageDialog(data.thumbnail ==
                                            null ||
                                        data.thumbnail == empty
                                    ? "https://mero.school/uploads/system/logo-dark.png"
                                    : data.thumbnail);

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return dialog;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 60, right: 16, bottom: 70),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    color: Colors.white,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: _selectedValue,
                                        onChanged: (Subscription? newValue) {
                                          setState(() {
                                            _selectedValue = newValue;
                                          });
                                        },
                                        items: data.subscription!.map<
                                                DropdownMenuItem<Subscription>>(
                                            (Subscription value) {
                                          return DropdownMenuItem<Subscription>(
                                            value: value,
                                            child: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child:
                                                          Text(value.package!),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${value.currency} ${value.price}",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: HexColor
                                                                  .fromHex(
                                                                      colorAccent)),
                                                        ),
                                                        SizedBox(
                                                          width: 24,
                                                        ),
                                                        Text(
                                                            "${value.validity} Days",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: HexColor
                                                                    .fromHex(
                                                                        colorBlue)))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.loose,
                                  child: ElevatedButton(
                                    child: Text(_selectedValue!.isPurchase!
                                        ? 'Renew'
                                        : 'Buy'),
                                    onPressed: () {
                                      Common.isUserLogin().then((value) {
                                        if (value) {
                                          _progressDialog.show();
                                          _plansSubscriptionBloc
                                              .smartCoursePayment(
                                                  course,
                                                  courseId,
                                                  price.toString(),
                                                  "",
                                                  "plan")
                                              .then((value) {
                                            _progressDialog.hide();
                                            ToastHelper.showShort(
                                                value.message!);
                                            Navigator.of(context).pushNamed(
                                                smart_payment_page,
                                                arguments: <String, String?>{
                                                  'paymentUrl': value
                                                      .data!.paymentProceed,
                                                });
                                          });
                                        } else {
                                          Navigator.pushNamed(
                                              context, login_page,
                                              arguments: <String, bool>{
                                                'isPreviousPage': true
                                              });
                                        }
                                      });
                                    },
                                    //secondColor
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return HexColor.fromHex(
                                                _selectedValue!.isPurchase!
                                                    ? secondColor
                                                    : colorAccent);
                                          return HexColor.fromHex(_selectedValue!
                                                  .isPurchase!
                                              ? secondColor
                                              : colorAccent); // Use the component's default.
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.only(bottom: 75),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return loadSingleItemCard(data.coursePlan![index]);
                }, childCount: data.coursePlan!.length),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tabTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: HexColor.fromHex("#EEEEEE"),
      child: TabBar(
        unselectedLabelColor: HexColor.fromHex(colorBlue),
        isScrollable: true,
        indicator: BoxDecoration(
            color: HexColor.fromHex(colorBlue), shape: BoxShape.rectangle),
        tabs: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Courses",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Details", style: TextStyle(fontSize: 18)),
          )
        ],
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  @override
  void dispose() {
    // _plansSubscriptionBloc.dispose();
    super.dispose();
  }

  Widget viewPagerApi(AppPlanData data) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [updateCourseWidget(data), updateCourseDetailsWidget(data)],
      ),
    );
  }

  Widget updateTopWidget(AppPlanData model) {
    if (model.subscription!.isNotEmpty) {
      if (_selectedValue == null) {
        _selectedValue = model.subscription![0];
      }
      var course;
      var courseId;
      double price = 0.0;
      if (model.coursePlan!.isNotEmpty) {
        course =
            [for (var element in model.coursePlan!) element.title].join(",");
        courseId =
            [for (var element in model.coursePlan!) element.id].join(",");
        model.coursePlan!.forEach((element) {
          if (element.price != null && element.price!.isNotEmpty == true) {
            price = price + double.parse(element.price.toString());
          }
        });
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.courseDuration!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .apply(color: Colors.white),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    color: Colors.white,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selectedValue,
                        onChanged: (Subscription? newValue) {
                          setState(() {
                            _selectedValue = newValue;
                          });
                        },
                        items: model.subscription!
                            .map<DropdownMenuItem<Subscription>>(
                                (Subscription value) {
                          return DropdownMenuItem<Subscription>(
                            value: value,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(value.package!),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${value.currency} ${value.price}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: HexColor.fromHex(
                                                  colorAccent)),
                                        ),
                                        SizedBox(
                                          width: 24,
                                        ),
                                        Text("${value.validity} Days",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: HexColor.fromHex(
                                                    colorBlue)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: ElevatedButton(
                    child: Text(_selectedValue!.isPurchase! ? 'Renew' : 'Buy'),
                    onPressed: () {
                      Common.isUserLogin().then((value) {
                        if (value) {
                          _progressDialog.show();
                          _plansSubscriptionBloc
                              .smartCoursePayment(course, courseId,
                                  price.toString(), "", "plan")
                              .then((value) {
                            _progressDialog.hide();
                            ToastHelper.showShort(value.message!);
                            Navigator.of(context).pushNamed(smart_payment_page,
                                arguments: <String, String?>{
                                  'paymentUrl': value.data!.paymentProceed,
                                });
                          });
                        } else {
                          Navigator.pushNamed(context, login_page,
                              arguments: <String, bool>{
                                'isPreviousPage': true
                              });
                        }
                      });
                    },
                    //secondColor
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return HexColor.fromHex(_selectedValue!.isPurchase!
                                ? secondColor
                                : colorAccent);
                          return HexColor.fromHex(_selectedValue!.isPurchase!
                              ? secondColor
                              : colorAccent); // Use the component's default.
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget updateCourseWidget(AppPlanData data) {
    return ListView.builder(
        itemCount: data.coursePlan!.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return loadSingleItemCard(data.coursePlan![index]);
        });
  }

  Widget loadSingleItemCard(Course_plan model) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, course_details,
            arguments: <String, String?>{
              'course_id': model.id,
              'title': model.title,
              'price': model.price,
              'thumbnail': model.thumbnail,
            });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0.0),
                      topLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(5.0)),
                  child: Container(
                    child: FadeInImage.assetNetwork(
                        image: model.thumbnail!,
                        placeholder: logo_placeholder,
                        height: 100,
                        width: 100,
                        fit: BoxFit.fitHeight),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${model.title.toString().toUpperCase()}",
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                HexColor.fromHex(bottomNavigationEnabledState)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${model.instructorName}",
                        style: TextStyle(
                            color:
                                HexColor.fromHex(bottomNavigationIdealState)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: model.ratings.toDouble(),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (double value) {},
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("${model.instructorName}"),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "( ${model.numberOfRatings.toString()} )",
                            style: TextStyle(
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget updateCourseDetailsWidget(AppPlanData data) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                data.shortDescription == null ? empty : data.shortDescription!,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.justify,
              ),
              MyDivider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text(
                  data.planDescription == null ? empty : data.planDescription!,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get _horizontalTitlePadding {
    const kBasePadding = 24.0;
    const kMultiplier = 0.5;

    if (_scrollController.hasClients) {
      if (_scrollController.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        return kBasePadding;
      }

      if (_scrollController.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        return (kExpandedHeight / 2 - kToolbarHeight) * kMultiplier +
            kBasePadding;
      }

      // In case 0%-50% of the expanded height is viewed
      return (_scrollController.offset - (kExpandedHeight / 2)) * kMultiplier +
          kBasePadding;
    }

    return kBasePadding;
  }
}
