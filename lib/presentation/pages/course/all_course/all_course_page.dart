
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mero_school/business_login/blocs/all_course_page_bloc.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical_fixed.dart';
import 'package:mero_school/presentation/widgets/search/all_course_search.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/image_error.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/utils/raw.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:mero_school/data/models/response/filter_course_response.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class AllCoursePage extends StatefulWidget {
  @override
  _AllCoursePageState createState() => _AllCoursePageState();
}

class _AllCoursePageState extends State<AllCoursePage> {
  // AllCourseBloc _allCourseBloc;

  late AllCoursePagiBloc _allCourseBloc;
  ScrollController? _controller;
  int offset = 0;

  String finalQuery = "";

  String? _chosenPrice = Raw.getPrice()[0];
  String? _chosenLevel = Raw.getLevel()[0];
  String? _chosenLanguage = Raw.getLanguage()[0];
  String? _chosenRating = Raw.getRating()[0];
  int _chosenRatingIndex = 0;
  String? _chosenCategory;
  String? _chosenCategoryId = "0";

  String? cid, diff, lang, src;
  String? cat_name;

  @override
  void initState() {
    _controller = ScrollController();
    // _controller.addListener(_scrollListener);//todo after pagination
    _allCourseBloc = AllCoursePagiBloc();
    _allCourseBloc.initBloc();

    super.initState();

    WebEngagePlugin.trackScreen(TAG_PAGE_ALL_COURSE);
    WebEngagePlugin.trackEvent(TAG_ALL_COURSE_CLICKED, {});
    init();
  }

  String? cc = "";

  init() async {
    var c = await Preference.getString(categoryList);
    cc = c;
    _chosenCategory = Raw.getCategory(c)[0];
  }

  void continueFilter(int skip) {
    var filterQuery = "";

    String? query = "";
    if (src != null && src != "null") {
      query = src;
    } else {
      if (cid != "all") {
        filterQuery = "$filterQuery AND category_id = $cid";
      }

      if (diff != "all") {
        filterQuery = "$filterQuery AND level = $diff";
      }

      if (lang != "all") {
        filterQuery = "$filterQuery AND language = $lang";
      }
    }

    finalQuery = "$query&offset=$skip&filters=status = active";

    print("==finalQuery : $finalQuery SkIP: $skip QUERY: $query");
    _allCourseBloc.fetchSearch(finalQuery, skip, query);
  }

  void parse(FilterCourseResponse response) {}

  void goBackOrOpenHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    print("_arguments; ${arguments.toString()}");

    // courseId = _arguments?['course_id'].toString();




    if (arguments != null && arguments['id'] != null && !arguments.containsKey('course_id')) {
      print("id: " + arguments['id']);
      // _allCourseBloc.fetchCategoryWiseCourse(arguments['id']);

      cid = arguments['id'];
      diff = all;
      lang = all;

      src = empty;

      cat_name = arguments['category_name'];

      _allCourseBloc.fetchAllCourse(
          arguments['id'], all, diff, lang, all, empty, cat_name!);


    }else if(arguments !=null && arguments['course_id'] !=null){

      cid = arguments['course_id'];


      if(cid ==null){
        cid = all;
      }

      if(cid?.isEmpty == true){
        cid = all;
      }


      diff = all;
      lang = all;

      src = empty;

      cat_name = 'Push/InApp';

      _allCourseBloc.fetchAllCourse(
          "$cid", all, diff, lang, all, empty, cat_name!);

    } else if (arguments != null &&
        arguments['search_string'] != null &&
        arguments['search_string'] != empty) {
      cid = all;
      diff = all;
      lang = all;

      src = arguments['search_string'];

      continueFilter(0);
      // _allCourseBloc.coursesBySearchString(arguments['search_string']);

    } else if (arguments != null &&
        arguments['_chosenCategoryId'] != null &&
        arguments['_chosenPrice'] != null &&
        arguments['_chosenLevel'] != null &&
        arguments['_chosenLanguage'] != null &&
        arguments['_chosenRatingIndex'] != null &&
        arguments['search_string'] != null) {
      cid = arguments['_chosenCategoryId'];
      diff = arguments['_chosenLevel'];
      lang = arguments['_chosenLanguage'];

      src = arguments['search_string'];

      // continueFilter(0);

      _allCourseBloc.fetchAllCourse(
          arguments['_chosenCategoryId'],
          arguments['_chosenPrice'],
          arguments['_chosenLevel'],
          arguments['_chosenLanguage'],
          arguments['_chosenRatingIndex'],
          arguments['search_string'],
          arguments['category_name']);
    } else {
      cid = all;
      diff = all;
      lang = all;

      cat_name = all;
      src = empty;

      _allCourseBloc.fetchAllCourse(
          cid!, all, diff, lang, all, empty, cat_name!);

    }

    final PagingController<int, FilterCourseResponse> _pagingController =
        PagingController(firstPageKey: 0);

    return Scaffold(
      appBar: AllCourseSearch(
        isAllCourse: true,
        isPlan: false,
        callback: (value) {
          offset = 0;
          src = value;
          cid = all;
          diff = all;
          lang = all;

          print("here ; $src");
          continueFilter(0);

          // _allCourseBloc.fetchSearch("$value&limit=10&offset=$offset&filters=status = active", offset);
        },
        back: () {
          // Navigator.of(context).pop();

          goBackOrOpenHome();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _filterModalBottomSheet(context);
        },
        child: Image.asset(
          ic_filter,
          height:32,
          width: 32,
        ),
      ),
      body: StreamBuilder<List<Data>>(
          stream: _allCourseBloc.allPlansDataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: PlaceHolderLoadingVerticalFixed());
            } else {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  offset = snapshot.data!.length;

                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Showing ${snapshot.data!.length} Courses",
                              style: TextStyle(
                                  color: HexColor.fromHex(colorDarkRed),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                            controller: _controller,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (snapshot.data != null &&
                                  snapshot.data!.length > 0) {
                                return loadSingleItemCard(
                                    snapshot.data![index]);
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  );
                } else {
                  return Error(
                    errorMessage: "Record not found",
                    isDisplayButton: false,
                  );
                }
              } else {
                return Center(child: PlaceHolderLoadingVerticalFixed());
              }
            }


          }),
      // ,
    );
  }

  @override
  void dispose() {
    _allCourseBloc.dispose();
    super.dispose();
  }

   Widget loadSingleItemCard(Data model) {
    return GestureDetector(
      onTap: () {
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
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
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
                        imageErrorBuilder: (_, __, ___) {
                          return ImageError();
                        },
                        fit: BoxFit.fitHeight),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title!.toUpperCase(),
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                HexColor.fromHex(bottomNavigationEnabledState)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        model.instructorName.toString(),
                        style: TextStyle(
                            color:
                                HexColor.fromHex(bottomNavigationIdealState)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Visibility(
                        visible: model.rating == 0 ? false : true,
                        child: Row(
                          children: [
                            RatingBar.builder(
                              itemSize: 20,
                              initialRating: model.rating.toDouble(),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (double value) {},
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(model.rating.toString()),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "( ${model.numberOfRatings.toString()} )",
                              style: TextStyle(
                                  color: HexColor.fromHex(
                                      bottomNavigationIdealState)),
                            ),
                            // SizedBox(
                            //   width: 40,
                            // ),
                            // Text(
                            //   model.price,
                            //   style: TextStyle(
                            //       color: HexColor.fromHex(colorAccent),
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
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

  void _filterModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (
          BuildContext bc,
        ) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Container(
              child: bottomDesign(state),
            );
          });
        });
  }

  Widget bottomDesign(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter Course",
                style: TextStyle(
                    color: HexColor.fromHex(colorAccent),
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  AntDesign.closecircleo,
                  color: HexColor.fromHex(bottomNavigationEnabledState),
                ),
              )
            ],
          ),
          Divider(
            color: HexColor.fromHex(bottomNavigationIdealState),
          ),
          categoryWidget(setState),
          priceWidget(setState),
          levelWidget(setState),
          languageWidget(setState),
          ratingWidget(setState),
          buttonWidget(setState)
        ],
      ),
    );
  }

  Widget priceWidget(StateSetter setState) {
    return Visibility(
      visible: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Price",
            style:
                TextStyle(color: HexColor.fromHex(bottomNavigationIdealState)),
          ),
          SizedBox(
            width: 50,
          ),
          Container(
            width: 200,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 3, 10),
                child: DropdownButton<String>(
                  value: _chosenPrice,
                  style: TextStyle(color: Colors.black87),
                  isExpanded: true,
                  underline: Text(''),
                  icon: Icon(
                    MaterialIcons.signal_cellular_4_bar,
                    color: HexColor.fromHex(bottomNavigationIdealState),
                  ),
                  items: Raw.getPrice()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  elevation: 16,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      _chosenPrice = newValue;
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget levelWidget(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Level",
            style:
                TextStyle(color: HexColor.fromHex(bottomNavigationIdealState)),
          ),
          SizedBox(
            width: 50,
          ),
          Container(
            width: 200,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 3, 10),
                child: DropdownButton<String>(
                  value: _chosenLevel,
                  style: TextStyle(color: Colors.black87),
                  isExpanded: true,
                  underline: Text(''),
                  icon: Icon(
                    MaterialIcons.signal_cellular_4_bar,
                    color: HexColor.fromHex(bottomNavigationIdealState),
                  ),
                  items: Raw.getLevel()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  elevation: 16,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      _chosenLevel = newValue;
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget languageWidget(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Language",
            style:
                TextStyle(color: HexColor.fromHex(bottomNavigationIdealState)),
          ),
          SizedBox(
            width: 50,
          ),
          Container(
            width: 200,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 3, 10),
                child: DropdownButton<String>(
                  value: _chosenLanguage,
                  style: TextStyle(color: Colors.black87),
                  isExpanded: true,
                  underline: Text(''),
                  icon: Icon(
                    MaterialIcons.signal_cellular_4_bar,
                    color: HexColor.fromHex(bottomNavigationIdealState),
                  ),
                  items: Raw.getLanguage()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  elevation: 16,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      _chosenLanguage = newValue;
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ratingWidget(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Rating",
            style:
                TextStyle(color: HexColor.fromHex(bottomNavigationIdealState)),
          ),
          SizedBox(
            width: 50,
          ),
          Container(
            width: 200,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 3, 10),
                child: DropdownButton<String>(
                  value: _chosenRating,
                  style: TextStyle(color: Colors.black87),
                  isExpanded: true,
                  underline: Text(''),
                  icon: Icon(
                    MaterialIcons.signal_cellular_4_bar,
                    color: HexColor.fromHex(bottomNavigationIdealState),
                  ),
                  items: Raw.getRating()
                      .map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!),
                    );
                  }).toList(),
                  elevation: 16,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      _chosenRating = newValue;
                      _chosenRatingIndex =
                          Raw.getRating().indexOf(_chosenRating);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonWidget(StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() async {
                var c = await Preference.getString(categoryList);

                _chosenPrice = Raw.getPrice()[0];
                _chosenLevel = Raw.getLevel()[0];
                _chosenLanguage = Raw.getLanguage()[0];
                _chosenRating = Raw.getRating()[0];
                _chosenCategory = Raw.getCategory(c)[0];
                _chosenRatingIndex = 0;
                _chosenCategoryId = "0";
              });
            },
            child: Text("RESET"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return HexColor.fromHex(colorAccent);
                  return HexColor.fromHex(
                      colorBlue); // Use the component's default.
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              cid =
                  _chosenCategoryId == "0" ? all : _chosenCategoryId.toString();
              diff = _chosenLevel!.toLowerCase();
              lang = _chosenLanguage!.toLowerCase();

              src = empty;

              // continueFilter(0);

              print("choosedCatId: $_chosenCategoryId");

              _allCourseBloc.myData.clear();
              _allCourseBloc.fetchAllCourse(
                  _chosenCategoryId == '0'
                      ? 'all'
                      : _chosenCategoryId.toString(),
                  _chosenPrice!.toLowerCase(),
                  _chosenLevel!.toLowerCase(),
                  _chosenLanguage!.toLowerCase(),
                  _chosenRatingIndex == 0 ? all : _chosenRatingIndex.toString(),
                  empty,
                  _chosenCategory!);

              Navigator.of(context).pop();
            },
            child: Text("APPLY"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return HexColor.fromHex(colorAccent);
                  return HexColor.fromHex(
                      colorAccent); // Use the component's default.
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget categoryWidget(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Category",
            style:
                TextStyle(color: HexColor.fromHex(bottomNavigationIdealState)),
          ),
          SizedBox(
            width: 50,
          ),
          Container(
            width: 200,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 3, 10),
                child: DropdownButton<String>(
                  value: _chosenCategory,
                  style: TextStyle(color: Colors.black87),
                  isExpanded: true,
                  underline: Text(''),
                  icon: Icon(
                    MaterialIcons.signal_cellular_4_bar,
                    color: HexColor.fromHex(bottomNavigationIdealState),
                  ),
                  items: Raw.getCategory(cc)
                      .map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!),
                    );
                  }).toList(),
                  elevation: 16,
                  isDense: true,
                  onChanged: (newValue) async {
                    String? c = await (Preference.getString(categoryList));
                    String? elId = "0";
                    Raw.getCategoryWithModel("$c").forEach((element) {
                      if (newValue == element.name) {
                        // _chosenCategoryId = element.id;
                        elId = element.id;
                      }
                    });

                    setState(() {
                      _chosenCategory = newValue;
                      _chosenCategoryId = elId;
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
