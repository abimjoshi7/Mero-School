import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:mero_school/business_login/blocs/all_plans_bloc.dart';
import 'package:mero_school/business_login/blocs/splash_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:mero_school/main.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/pages/account/profile/profile_page.dart';
import 'package:mero_school/presentation/pages/course/all_plans/all_plans_page.dart';
import 'package:mero_school/presentation/pages/more_page.dart';
import 'package:mero_school/presentation/pages/my_course/my_course_page.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/my_navigation_bar.dart';
import 'package:mero_school/presentation/widgets/search/all_course_search.dart';
import 'package:mero_school/quiz/blocs/quiz_bloc.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/utils/raw.dart';
import 'package:provider/provider.dart';

import 'course/course_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> with WidgetsBindingObserver {
  MyNavigationBar? _myNavigationBar;

  int _selectedIndex = 0;
  String? _chosenPrice = Raw.getPrice()[0];
  String? _chosenLevel = Raw.getLevel()[0];
  String? _chosenLanguage = Raw.getLanguage()[0];
  String? _chosenRating = Raw.getRating()[0];
  int _chosenRatingIndex = 0;
  String? _chosenCategory = "";
  String? _chosenCategoryId = "0";
  String _chosenCategoryName = "";
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  late QuizBloc _quizBloc;
  AppUpdateInfo? _updateInfo;
  late AppLifecycleState _appLifecycleState;
  bool _flexibleUpdateAvailable = false;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) => showSnack(e));
      }
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  late UserStateViewModel _userStateViewModel;
  late SplashBloc _splashBloc;

  @override
  void initState() {
    init();

    _userStateViewModel = UserStateViewModel();
    _userStateViewModel.check();

    _myNavigationBar = new MyNavigationBar(onItemTapped: onItemTapped);

    super.initState();

    _quizBloc = QuizBloc();
    _quizBloc.initBloc();

    _splashBloc = SplashBloc();
    _splashBloc.systemSettingsBloc();
    _splashBloc.fetchSystemSettings();

    checkForQuiz();
  }

  String? cc = "";

  init() async {
    var c = await Preference.getString(categoryList);
    cc = c;
    _chosenCategory = Raw.getCategory(cc)[0];
  }

  Future<void> checkForQuiz() async {
    var today = DateFormat.yMMMd().format(DateTime.now());
    var previous = await Preference.getString("last_display_date");
    if (today != previous) {
      _quizBloc.fetchTopic();
    }
  }

  @override
  void didChangeDependencies() {
    if (Platform.isAndroid) {
      checkForUpdate();
    }
    _splashBloc.fetchSystemSettings();

    // notificationPermission();

    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;

    print("UNITED STATES: " + _appLifecycleState.toString());
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    try {
      _quizBloc.dispose();
      _allPlansBloc.dispose();
    } catch (e) {
      print(e);
    }
    _splashBloc.close();

    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void getToken() async {
    // Preference.load();

    var result = await Preference.getString(token);

    debugPrint(result);

    debugPrint(await messaging.getToken());
  }

  // void notificationPermission() async {
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   print('User granted permission: ${settings.authorizationStatus}');
  //
  //   // try {
  //   //   await messaging.subscribeToTopic(topic);
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   //
  // }

  List<Widget> _widgetOptions = <Widget>[
    CoursePage(),
    MyCoursePage(),
    AllPlansPage(
      isBottomSheet: true,
    ),
    ProfilePage(),
    MorePage()
  ];

  late AllPlansBloc _allPlansBloc;

  @override
  Widget build(BuildContext context) {
    _allPlansBloc = Provider.of<AllPlansBloc>(context, listen: false);

    _quizBloc.dataStream.listen((event) {
      print("event $event");
      if (event.data != null && event.data!.length > 0) {
        Navigator.of(context).pushNamed(quiz_home_page);
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AllCourseSearch(
        isAllCourse: false,
        isPlan: _selectedIndex == 2 ? true : false,
        callback: (searchQuery) {
          analytics.logEvent(name: SEARCH, parameters: <String, String>{
            SEARCH_TERM: searchQuery,
          });

          print("---search query : $searchQuery  $_selectedIndex");

          if (_selectedIndex == 2) {
            _allPlansBloc.searchPlan(searchQuery);

            // Navigator.pushNamed(context, all_course,
            //     arguments: <String, String>{'search_string': searchQuery});

          } else {
            Navigator.pushNamed(context, all_course,
                arguments: <String, String>{'search_string': searchQuery});
          }
        },
        back: () {
          Navigator.of(context).pop();
        },
      ),
      bottomNavigationBar: _myNavigationBar,
      body: Stack(
        children: [
          Error(
            errorMessage: "loading, please wait..",
            isDisplayButton: false,
          ),
          Stack(
            children: [
              Container(color: Colors.white),
              Container(child: _widgetOptions.elementAt(_selectedIndex)),
            ],
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _selectedIndex == 0 ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            init();

            _filterModalBottomSheet(context);
          },
          child: Image.asset(
            ic_filter,
            height: 32,
            width: 32,
          ),
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _filterModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (
          BuildContext bc,
        ) {
          print("${Raw.getCategory(cc)} category List:");

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
          )
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
              setState(() {
                _chosenPrice = Raw.getPrice()[0];
                _chosenLevel = Raw.getLevel()[0];
                _chosenLanguage = Raw.getLanguage()[0];
                _chosenRating = Raw.getRating()[0];
                _chosenCategory = Raw.getCategory(cc)[0];
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
              Navigator.of(context).pop();
              Navigator.pushNamed(context, all_course,
                  arguments: <String, String?>{
                    '_chosenCategoryId': _chosenCategoryId == "0"
                        ? all
                        : _chosenCategoryId.toString(),
                    '_chosenPrice': _chosenPrice!.toLowerCase(),
                    '_chosenLevel': _chosenLevel!.toLowerCase(),
                    '_chosenLanguage': _chosenLanguage!.toLowerCase(),
                    '_chosenRatingIndex': _chosenRatingIndex == 0
                        ? all
                        : _chosenRatingIndex.toString(),
                    'search_string': empty,
                    'category_name': _chosenCategory
                  });
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
                    String? c = await Preference.getString(categoryList);
                    String? cid = "0";
                    Raw.getCategoryWithModel(c.toString()).forEach((element) {
                      if (newValue == element.name) {
                        cid = element.id;
                      }
                    });

                    setState(() {
                      _chosenCategory = newValue;
                      _chosenCategoryId = cid;
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
