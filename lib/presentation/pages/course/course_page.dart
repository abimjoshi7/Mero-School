import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:mero_school/business_login/blocs/course_bloc.dart';
import 'package:mero_school/business_login/blocs/user_data_bloc.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart'
    as planData;
import 'package:mero_school/data/models/response/categories_response.dart';
import 'package:mero_school/data/models/response/entrance_config.dart';
import 'package:mero_school/data/models/response/top_course_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/custom_image_dialog.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/mydivider.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/image_error.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../../business_login/blocs/edit_profile_bloc.dart';
import '../../../utils/animation_image.dart';
import '../../../utils/app_progress_dialog.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserDataBloc _userDataBloc;
  late CourseBloc _courseBloc;
  late EditProfileBloc _editProfileBloc;
  late AppProgressDialog _progressDialog;
  String? phoneNumber1;

  @override
  void initState() {
    _courseBloc = CourseBloc();
    _courseBloc.initBloc();
    super.initState();
    _userDataBloc = UserDataBloc();
    _editProfileBloc = EditProfileBloc();
    _editProfileBloc.init();

    WebEngagePlugin.trackScreen(TAG_PAGE_HOME);
  }

  @override
  Widget build(BuildContext context) {
    _courseBloc = Provider.of<CourseBloc>(context);
    _courseBloc.refreshEntrance();

    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<Response<TopCourseResponse>>(
              stream: _courseBloc.dataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      return Column(
                        children: [
                          loadText("Top Courses", "All Course", 1),
                          PlaceHolderLoading(),
                        ],
                      );

                    case Status.COMPLETED:
                      return Column(
                        children: [
                          loadText("Top Courses", "All Course", 1),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                                itemCount: snapshot.data!.data!.data!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return loadTopCourse(snapshot.data!, index);
                                }),
                          ),
                        ],
                      );
                      break;
                    case Status.ERROR:
                      return Column(
                        children: [
                          SizedBox(
                            child: AnimationImage(
                              path: ic_connection,
                              width: 150,
                            ),
                            height: 350,
                          ),
                          Error(
                              errorMessage: snapshot.data!.message,
                              onRetryPressed: () {
                                _refresh();
                                _courseBloc.fetchAllPlans();
                                // _courseBloc.fetchTopCourse();
                                _courseBloc.fetchCategories();
                              }),
                        ],
                      );
                      break;
                  }
                }
                return Container();
              }),
          StreamBuilder<Response<AllPlansResponse>>(
              stream: _courseBloc.allPlansDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("====111==== allplan ${snapshot.data!.status} }");

                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      // return Text("test2");
                      return PlaceHolderLoading();
                      break;
                    case Status.COMPLETED:
                      return Visibility(
                        visible: snapshot.data!.data!.data!.length > 0
                            ? true
                            : false,
                        child: Column(
                          children: [
                            loadText("Latest Plans", "All Plans", 2),
                            SizedBox(
                              height: 260,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.data!.data!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return loadSingleItemCardPlan(
                                        snapshot.data!, index);

                                    // return loadSingleItemCardPlan(snapshot.data!, index);
                                  }),
                            ),
                          ],
                        ),
                      );
                      break;
                    case Status.ERROR:
                      return Container();
                      // return Error(
                      //   errorMessage: snapshot.data.message,
                      //   onRetryPressed: () => _courseBloc.fetchAllPlans(),
                      // );
                      break;
                  }
                }
                return Container();
              }),
          StreamBuilder<Response<CategoriesResponse>>(
              stream: _courseBloc.categoriesDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      // return PlaceHolderLoadingVerticalFixed();
                      // return Center(
                      //     child: Column(
                      //   children: [
                      //     Text("No Internet connection. Try again."),
                      //     ElevatedButton(
                      //         onPressed: () {
                      //           return;
                      //         },
                      //         child: Text('Try again'))
                      //   ],
                      // ));
                      break;
                    case Status.COMPLETED:
                      _courseBloc.saveData(snapshot.data!.data);

                      return Column(
                        children: [
                          loadText("Categories", empty, 3),
                          StreamBuilder<Response<Entrance_config>>(
                            stream: _courseBloc.dataEntranceConfigStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.status == Status.COMPLETED) {
                                  return loadEntracneCard(
                                      snapshot.data!.data!, 2);
                                } else {
                                  return new Container();
                                }
                              } else {
                                return new Container();
                              }
                            },
                          ),
                          ListView.builder(
                              itemCount: snapshot.data!.data!.data!.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                if (snapshot.data!.data!.data![index]
                                        .numberOfCourses !=
                                    0) {
                                  return loadCategoriesCard(
                                      snapshot.data!, index);

                                  // var data = snapshot.data!.data!.data![index];

                                  // return loadSingleItemCardPlan(data);
                                }
                                return Container();
                              }),
                        ],
                      );
                      break;
                    case Status.ERROR:
                      return Error(
                        errorMessage: snapshot.data!.message,
                        onRetryPressed: () => _courseBloc.fetchCategories(),
                      );
                      break;
                  }
                }
                return Container();
              }),
        ],
      ),
    );
  }

  Future<void> showPopup() async {
    final number = await Preference.getString(phone_number);
    final tok = await Preference.getString(token);
    if (number!.isEmpty) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Enter your phone number:"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        bool phoneValid = value!.length > 8;
                        if (value.isEmpty) {
                          return ("This field can't be empty");
                        } else if (!phoneValid) {
                          return ("Phone is invalid.");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        phoneNumber1 = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final _biography1 = await Preference.getString(biography);
                      final _email1 = await Preference.getString(user_email);
                      final _facebook1 = await Preference.getString(facebook);
                      final _first1 = await Preference.getString(first_name);
                      final _last1 = await Preference.getString(last_name);
                      final _linkedin1 = await Preference.getString(linkedin);
                      final _twitter1 = await Preference.getString(twitter);

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final request = await http.post(
                            Uri.parse(
                                'https://mero.school/Api/update_userdata'),
                            body: {
                              "auth_token": "$tok",
                              "biography": _biography1,
                              "email": _email1,
                              "phone_number": phoneNumber1,
                              "gender": "",
                              "facebook_link": _facebook1,
                              "first_name": _first1,
                              "last_name": _last1!.isEmpty ? "." : _last1,
                              "linkedin_link": _linkedin1,
                              "twitter_link": _twitter1
                            });

                        print(request.statusCode);
                        print(request.body);
                        print("asdfqwer:$number");

                        if (request.statusCode == 200) {
                          Navigator.pop(context);
                        } else {
                          ToastHelper.showLong(
                              "This number is already in use in another account. Please use another number.");
                        }

                        // final result = _editProfileBloc.updateProfile(
                        //     biography1,
                        //     email1,
                        //     facebook1,
                        //     first1,
                        //     last1,
                        //     linkedin1,
                        //     twitter1,
                        //     phoneNumber1);

                        // Navigator.pop(context);
                      }
                    },
                    child: Center(child: Text("Submit")),
                  ),
                ),
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    // _courseBloc.dispose();
    super.dispose();
    _userDataBloc.dispose();

    _editProfileBloc.dispose();
  }

  Widget loadTopCourse(Response<TopCourseResponse> data, int index) {
    var model = data.data!.data![index];
    log(model.videoUrl ?? "No video url", level: 2);
    // var r = model.rating as double;

    return GestureDetector(
      onTap: () {
        print('${model.id} courseID');

        Navigator.pushNamed(context, course_details,
            arguments: <String, String?>{
              'course_id': model.id,
              'title': model.title,
              'price': model.price,
              'shareableLink': model.shareableLink,
              'thumbnail': model.thumbnail,
              'enrollment': model.totalEnrollment.toString(),
              'video_url': model.videoUrl,
            });

        // Navigator.pushNamed(context, est,
        //     arguments: <String, String?>{
        //       'course_id': model.id,
        //       'title': model.title,
        //       'price': model.price,
        //       'shareableLink': model.shareableLink,
        //       'thumbnail': model.thumbnail,
        //       'enrollment': model.totalEnrollment.toString(),
        //       'video_url': model.videoUrl,
        //     });
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 8,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(0.0),
                        bottomLeft: Radius.circular(0.0)),
                    child: Container(
                      // child: FadeInImage.assetNetwork(image: model.thumbnail,
                      //     placeholder: logo_placeholder,
                      //     height: 140,
                      //     width: MediaQuery.of(context).size.width,
                      //     fit: BoxFit.fill,
                      //     imageErrorBuilder: (_,__,___){
                      //       return ImageError(size: 140,);
                      //     },
                      // ),

                      child: CachedNetworkImage(
                          placeholder: (_, __) {
                            return Image.asset(logo_placeholder);
                          },
                          imageUrl: model.thumbnail!,
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          errorWidget: (_, __, ___) {
                            return ImageError(size: 140);
                          }),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      model.title!.toUpperCase(),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color:
                              HexColor.fromHex(bottomNavigationEnabledState)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RatingBar.builder(
                      itemSize: 20,
                      initialRating: model.rating.toDouble(),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: HexColor.fromHex(colorGolden),
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (double value) {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadLatestPlansCard(Response<AllPlansResponse> data, int index) {
    var myList = data.data!.data!;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, plans_details_page,
            arguments: <String, planData.AppPlanData>{'model': myList[index]});

        // //
        // Navigator.pushNamed(
        //     context,
        //     plans_details_page,arguments: <String, dynamic>{'plan_id': myList[index].id}
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: (MediaQuery.of(context).size.width / 2) - 8,
          child: Card(
            margin: EdgeInsets.all(4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(myList[index].plans! + "",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: HexColor.fromHex(
                                    bottomNavigationEnabledState))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  MyDivider(),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Text(myList[index].courseDuration!,
                        style: TextStyle(
                            color: HexColor.fromHex(
                                bottomNavigationEnabledState))),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  MyDivider(),
                  SizedBox(
                    height: 5,
                  ),
                  Text("  ${myList[index].subscription!.length} Subscriptions",
                      style: TextStyle(color: HexColor.fromHex(colorAccent))),
                  SizedBox(
                    height: 5,
                  ),
                  MyDivider(),
                  SizedBox(
                    height: 5,
                  ),
                  Text("  ${myList[index].coursePlan!.length} Courses",
                      style: TextStyle(
                          color:
                              HexColor.fromHex(bottomNavigationEnabledState))),
                  SizedBox(
                    height: 5,
                  ),
                  MyDivider(),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                          myList[index].shortDescription == null
                              ? empty
                              : myList[index].shortDescription!,
                          maxLines: 2,
                          style: TextStyle(
                              color: HexColor.fromHex(
                                  bottomNavigationEnabledState))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadLatestPlansCardV2(Response<AllPlansResponse> data, int index) {
    var myList = data.data!.data!;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, plans_details_page,
            arguments: <String, planData.AppPlanData>{'model': myList[index]});

        // //
        // Navigator.pushNamed(
        //     context,
        //     plans_details_page,arguments: <String, dynamic>{'plan_id': myList[index].id}
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: (MediaQuery.of(context).size.width / 2) - 8,
          child: Card(
            margin: EdgeInsets.all(4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(myList[index].plans! + "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: HexColor.fromHex(
                                      bottomNavigationEnabledState))),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  CachedNetworkImage(
                      placeholder: (_, __) {
                        return Image.asset(logo_placeholder);
                      },
                      imageUrl: myList[index].thumbnail!,
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                      errorWidget: (_, __, ___) {
                        return ImageError(size: 140);
                      }),

                  // SizedBox(
                  //   height: 5,
                  // ),
                  // MyDivider(),
                  SizedBox(
                    height: 5,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  //   child: Text(myList[index].courseDuration!,
                  //       style: TextStyle(
                  //           color: HexColor.fromHex(
                  //               bottomNavigationEnabledState))),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // MyDivider(),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text("  ${myList[index].subscription!.length} Subscriptions",
                  //     style: TextStyle(color: HexColor.fromHex(colorAccent))),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // MyDivider(),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text("  ${myList[index].coursePlan!.length} Courses",
                  //     style: TextStyle(
                  //         color:
                  //         HexColor.fromHex(bottomNavigationEnabledState))),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // MyDivider(),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                          myList[index].shortDescription == null
                              ? empty
                              : myList[index].shortDescription!,
                          maxLines: 2,
                          style: TextStyle(
                              color: HexColor.fromHex(
                                  bottomNavigationEnabledState))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadSingleItemCardPlan(Response<AllPlansResponse> data, int index) {
    var model = data.data?.data?[index];
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, plans_details_page,
            arguments: <String, AppPlanData>{'model': model!});
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                  child: Text('${model?.plans}',
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
                width: 340,
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
                            var dialog = CustomImageDialog(model?.thumbnail);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              },
                            );
                          },
                          child: FadeInImage.assetNetwork(
                              image: model!.thumbnail!,
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
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
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

  Widget loadCategoriesCard(Response<CategoriesResponse> data, int index) {
    var model = data.data!.data![index];
    var myColors;
    if (index % 3 == 0) {
      myColors = HexColor.fromHex(firstColor);
    } else if ((index - 2) % 3 == 0) {
      myColors = HexColor.fromHex(secondColor);
    } else {
      myColors = HexColor.fromHex(thirdColor);
    }

    return GestureDetector(
      onTap: () {
        WebEngagePlugin.trackEvent(TAG_PAGE_COURSE_CATEGORY_VIEWED, {
          //'category_id': int.parse(model.id),
          'Category Id': int.parse(model.id!),
          //'category_name': model.name,
          'Category Name': model.name,
          //'total_courses': model.numberOfCourses,
          'Total Courses': model.numberOfCourses,
        });

        Navigator.pushNamed(context, all_course, arguments: <String, String?>{
          'id': model.id,
          'category_name': model.name
        });
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: myColors,
        child: Row(
          children: [
            Expanded(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(0.0),
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(8.0)),
                      child: Container(
                        // child: FadeInImage.assetNetwork(
                        //     image: model.thumbnail,
                        //     imageErrorBuilder: (context, error, trace){
                        //       return ImageError();
                        //     },
                        //     placeholder: logo_placeholder,
                        //     height: 75,
                        //     fit: BoxFit.fill),

                        child: CachedNetworkImage(
                            placeholder: (_, __) {
                              return Image.asset(logo_placeholder);
                            },
                            imageUrl: model.thumbnail!,
                            height: 75,
                            fit: BoxFit.fill,
                            errorWidget: (_, __, ___) {
                              return ImageError();
                            }),
                      )),

                  // FadeInImage.assetNetwork(
                  //   placeholder: logo,
                  //   image: model.thumbnail,
                  //   height: 75,
                  // ),

                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${model.name}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            softWrap: true,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text("${model.numberOfCourses} Courses",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                FontAwesome.long_arrow_right,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadEntracneCard(Entrance_config data, int index) {
    var model = data.data!;

    var myColors;
    if (index % 3 == 0) {
      myColors = HexColor.fromHex(firstColor);
    } else if ((index - 2) % 3 == 0) {
      myColors = HexColor.fromHex(secondColor);
    } else {
      myColors = HexColor.fromHex(thirdColor);
    }

    return GestureDetector(
      onTap: () async {
        Navigator.of(context).pushNamed(web_page_entrance,
            arguments: <String, String>{'paymentUrl': "${model.url}"});

        // WebEngagePlugin.trackEvent(TAG_PAGE_COURSE_CATEGORY_VIEWED, {
        //   //'category_id': int.parse(model.id),
        //   'Category Id': int.parse(model.id),
        //   //'category_name': model.name,
        //   'Category Name': model.name,
        //   //'total_courses': model.numberOfCourses,
        //   'Total Courses': model.numberOfCourses,
        // });

        // String? token = await Preference.getString(user_token);
        //
        // if (token != null && token.isNotEmpty) {
        //
        //
        //
        // } else {
        //   Navigator.of(context).pushNamed(login_page);
        // }

        //
        // Navigator.pushNamed(context, all_course,
        //     arguments: <String, String>{'id': model.id, 'category_name':model.name} );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: myColors,
        child: Row(
          children: [
            Expanded(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(0.0),
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(8.0)),
                      child: Container(
                        // child: FadeInImage.assetNetwork(
                        //     image: model.thumbnail,
                        //     imageErrorBuilder: (context, error, trace){
                        //       return ImageError();
                        //     },
                        //     placeholder: logo_placeholder,
                        //     height: 75,
                        //     fit: BoxFit.fill),

                        child: CachedNetworkImage(
                            placeholder: (_, __) {
                              return Image.asset(logo_placeholder);
                            },
                            imageUrl: model.thumbnail!,
                            height: 75,
                            fit: BoxFit.fill,
                            errorWidget: (_, __, ___) {
                              return ImageError();
                            }),
                      )),

                  // FadeInImage.assetNetwork(
                  //   placeholder: logo,
                  //   image: model.thumbnail,
                  //   height: 75,
                  // ),

                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${model.title}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            softWrap: true,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text("${model.subtitle}",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              )),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                FontAwesome.long_arrow_right,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadText(String start, String end, int id) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              start,
              style: TextStyle(
                  fontSize: 15,
                  color: HexColor.fromHex(colorDarkRed),
                  fontWeight: FontWeight.w800),
            ),
          ),
          InkWell(
            onTap: () {
              if (id == 1 || id == 3) {
                Navigator.pushNamed(context, all_course);
              } else {
                Navigator.pushNamed(context, all_plans);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    end,
                    style: TextStyle(color: HexColor.fromHex(colorBlue)),
                  ),
                  Visibility(
                    visible: id == 3 ? false : true,
                    child: Icon(
                      AntDesign.doubleright,
                      size: 12,
                      color: HexColor.fromHex(colorBlue),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _refresh() {
    _courseBloc.refresh();
    // return;
  }
}
