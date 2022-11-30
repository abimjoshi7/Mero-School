import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mero_school/business_login/blocs/my_wish_list_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/pages/account/account_page.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_grid.dart';
import 'package:mero_school/presentation/widgets/wish_list_alert_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/data/models/response/my_wishlist_response.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class WishListPage extends StatefulWidget {
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  late MyWishListBloc _myWishListBloc;
  List? _myList;

  @override
  void initState() {
    _myWishListBloc = MyWishListBloc();
    // _myWishListBloc.initBloc();
    super.initState();

    WebEngagePlugin.trackScreen(TAG_PAGE_WISH_LIST);
  }

  @override
  Widget build(BuildContext context) {
    var home = Consumer<UserStateViewModel>(
      builder: (_, auth, __) {
        if (auth.loginToken == null) {
          return Container();
        }

        if (auth.loginToken!.isNotEmpty) {
          _myWishListBloc.initBloc();
          return mainView();
        } else {
          return AccountPage();
        }
      },
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: HexColor.fromHex(bottomNavigationEnabledState)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Image.asset(
            logo_no_text,
            height: 38,
            width: 38,
          ),
        ),
        body: home);
  }

  Widget mainView() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Wishlist",
                style: TextStyle(
                    color: HexColor.fromHex(colorDarkRed),
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, my_carts);
                  },
                  child: Row(
                    children: [
                      Text(
                        "My Carts",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: HexColor.fromHex(colorBlue)),
                      ),
                      Icon(
                        AntDesign.doubleright,
                        size: 12,
                        color: HexColor.fromHex(colorBlue),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        StreamBuilder<Response<MyWishlistResponse>>(
            stream: _myWishListBloc.dataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return PlaceHolderLoadingGrid();
                    break;
                  case Status.COMPLETED:
                    if (_myList != null && _myList!.isNotEmpty) {
                      _myList!.clear();
                    }
                    _myList = snapshot.data!.data!.data;
                    return Flexible(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          padding: EdgeInsets.all(8),
                          children: List.generate(_myList!.length, (index) {
                            return loadCardItem(_myList![index]);
                          })),
                    );
                    // return Container(
                    //   child: Image.asset(
                    //       logo, height: 50, fit: BoxFit.contain),
                    // );

                    // return mainView(displayJoke: snapshot.data.data);
                    break;
                  case Status.ERROR:
                    return Error(
                      errorMessage: snapshot.data!.message,
                      onRetryPressed: () => _myWishListBloc.fetchData(),
                    );
                    break;
                }
              }
              return Container();
            })
      ],
    );
  }

  @override
  void dispose() {
    _myWishListBloc.dispose();
    super.dispose();
  }

  Widget loadCardItem(Data model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          openCourseDetails(model);
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0.0)),
                      child: Container(
                        child: Image.network(model.thumbnail!,
                            height: 110,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      model.title!,
                      softWrap: true,
                      style: TextStyle(
                          color:
                              HexColor.fromHex(bottomNavigationEnabledState)),
                    ),


                  ),


                  RatingBar.builder(
                    itemSize: 20,
                    initialRating: model.rating.toDouble(),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: HexColor.fromHex(colorGolden),
                    ),
                    ignoreGestures: true,
                    onRatingUpdate: (double value) {},
                  ),









                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: PopupMenuButton<String>(
                  //
                  //       icon: Image.asset(ic_menu),
                  //       onSelected: (String item) {
                  //         switch (item) {
                  //           case "Remove":
                  //             {
                  //               VoidCallback continueCallBack = () =>
                  //               {
                  //                 Navigator.of(context).pop(),
                  //                 callRemoveApi(model)
                  //                 // // code on continue comes here
                  //               };
                  //               var dialog = WishListAlertDialog(
                  //                   "Confirmation",
                  //                   "Do you really want to remove this course from your wishlist?",
                  //                   continueCallBack);
                  //
                  //               showDialog(
                  //                 context: context,
                  //                 builder: (BuildContext context) {
                  //                   return dialog;
                  //                 },
                  //               );
                  //               break;
                  //             }
                  //           case "Course" :
                  //             {
                  //               openCourseDetails(model);
                  //               break;
                  //             }
                  //         }
                  //       },
                  //
                  //       itemBuilder: (BuildContext context) {
                  //         return [
                  //           PopupMenuItem(value: "Remove", child: Text("Remove")),
                  //           PopupMenuItem(
                  //               value: "Course", child: Text("Course Details"))
                  //         ];
                  //       }),
                  // )
                ],
              ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              VoidCallback continueCallBack = () => {
                                Navigator.of(context).pop(),
                                callRemoveApi(model)
                                // // code on continue comes here
                              };
                              var dialog = WishListAlertDialog(
                                  "Confirmation",
                                  "Do you really want to remove this course from your wishlist?",
                                  continueCallBack);

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return dialog;
                                },
                              );
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.black26,
                          ),
                          IconButton(
                            onPressed: () {
                              openCourseDetails(model);
                            },
                            icon: Icon(Icons.remove_red_eye),
                            color: Colors.black26,
                          )
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void openCourseDetails(Data model) {
    Navigator.pushNamed(context, course_details, arguments: <String, String?>{
      'course_id': model.id,
      'title': model.title,
      'price': model.price,
      'shareableLink': model.shareableLink,
      'thumbnail': model.thumbnail,
      'enrollment': model.totalEnrollment.toString(),
      'video_url': model.videoUrl,
    });
  }

  void callRemoveApi(Data data) {
    print("DISCOUNTFLAG" + data.discountFlag.toString());
    var priceToSend = 0.0;
    var discountPrice = 0.0;

    var courseCreatedBy = data.instructorName ?? "";
    if (data.price == "Free" || data.price!.isEmpty) {
      priceToSend = 0.0;
    } else if (data.discountFlag.trim() == "1") {
      priceToSend = double.parse(data.discountedPrice!);
      discountPrice =
          double.parse(data.price!) - double.parse(data.discountedPrice!);
    } else {
      priceToSend = double.parse(data.price!);
    }

    print("Price: $priceToSend :: Discount: $discountPrice");
    //print("=<>="+double.parse(snapshot.data.data.price).runtimeType.toString());
    //INFO OUT
    WebEngagePlugin.trackEvent(TAG_WISHLIST_REMOVED, {
      'Category Id': int.parse(data.categoryId!),
      'Category Name': data.title ?? "",
      'Course Time Duration': "",
      'Course Created By': courseCreatedBy,
      'id': int.parse(data.id!),
      'is_purchased': null,
      'Course Level': "${data.level}",
      'Language': data.language,
      'Price':
          priceToSend, //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
      'Discount':
          discountPrice, //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
      'Course Ratings': data.rating,
      'Course Name': data.title,
      'Total Enrollments': data.totalEnrollment,
    });

    _myWishListBloc.removeData(data.id).then((value) => {
          setState(() {
            _myList!.remove(data);
          })
        });
  }
}
