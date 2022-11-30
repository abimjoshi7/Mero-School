import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http/http.dart' as http;
import 'package:mero_school/business_login/blocs/splash_bloc.dart';
import 'package:mero_school/business_login/blocs/user_data_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:mero_school/data/models/response/system_settings_response.dart';
import 'package:mero_school/data/models/response/user_data_response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/app_menu.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../networking/Response.dart';
import '../../utils/toast_helper.dart';
import '../widgets/affiliate_options.dart';
import '../widgets/loading/mydivider.dart';

class MorePage extends StatefulWidget {
  MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() {
    return _MorePageState();
  }
}

class _MorePageState extends State<MorePage> {
  late AppProgressDialog _progressDialog;
  late bool _passwordVisible;
  late UserDataBloc _userDataBloc;
  SystemSettingsResponse? _response;
  late SplashBloc _splashBloc;
  String? fetchToken;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
    _splashBloc = SplashBloc();
    _splashBloc.systemSettingsBloc();
    _splashBloc.fetchSystemSettings();
    _userDataBloc = UserDataBloc();
    _userDataBloc.initBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchToken = Provider.of<UserStateViewModel>(context).loginToken;
  }

  @override
  void dispose() {
    super.dispose();
    _splashBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final _args123 = ModalRoute.of(context)!.settings.arguments ?? "HELLO";

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // MoreMenu(
                  //   title: "test",
                  //   icon: Icons.add,
                  //   callback: () async {
                  //     print(fetchToken);
                  //     fetchUser().then(
                  //       (value) => print(
                  //         value.toJson(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  MoreMenu(
                    title: "Play Quiz",
                    icon: Icons.help_outlined,
                    callback: () {
                      Navigator.of(context).pushNamed(quiz_home_page);
                    },
                    isLast: false,
                  ),
                  MoreMenu(
                    title: "Quiz Results",
                    icon: Entypo.trophy,
                    callback: () {
                      Navigator.of(context).pushNamed(quiz_result_page);
                    },
                    isLast: false,
                  ),
                  FutureBuilder<String?>(
                      future: _getNumber(),
                      builder: (context, snapshot) {
                        var number = "";
                        if (snapshot.hasData) {
                          number = "${snapshot.data}";
                        }

                        return MoreMenu(
                          title: "$number",
                          icon: Icons.phone,
                          callback: () {
                            _launchCaller();
                          },
                          isLast: false,
                        );
                      }),
                  FutureBuilder(
                      future: _getEmail(),
                      builder: (context, snapshot) {
                        var email = "info@mero.school";
                        if (snapshot.hasData) {
                          email = "${snapshot.data}";
                        }
                        return MoreMenu(
                          title: "$email",
                          icon: Icons.mail,
                          callback: () {
                            _emailLaunchUri(email);
                          },
                          isLast: false,
                        );
                      }),
                  StreamBuilder<Response<SystemSettingsResponse>>(
                      stream: _splashBloc.settingDataStream,
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status) {
                            case Status.LOADING:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case Status.COMPLETED:
                              return fetchToken!.isEmpty
                                  ? Visibility(
                                      child: MoreMenu(
                                        isLast: false,
                                        title: "Become an affiliate",
                                        icon: Icons
                                            .connect_without_contact_rounded,
                                        callback: () async {
                                          Navigator.pushNamed(
                                              context, affiliate_page);
                                        },
                                      ),
                                      visible: snapshot.data!.data!.data!
                                                  .hideAffiliate ==
                                              "false"
                                          ? true
                                          : false,
                                    ) // System Setting Visiblity non-logged user
                                  : FutureBuilder<UserDataResponse>(
                                      future: fetchUser(),
                                      builder: (_, response) {
                                        if (response.hasData &&
                                            response.data!.data != null) {
                                          switch (response
                                              .data!.data!.affiliateStatus) {
                                            case "approved":
                                              return Column(
                                                children: [
                                                  AffiliateOptions(
                                                    snapshot: snapshot,
                                                  ),
                                                  MyDivider(),
                                                ],
                                              );
                                            case "blocked":
                                              return SizedBox();
                                            default:
                                              return Visibility(
                                                child: MoreMenu(
                                                  isLast: false,
                                                  title: "Become an affiliate",
                                                  icon: Icons
                                                      .connect_without_contact_rounded,
                                                  callback: () async {
                                                    Navigator.pushNamed(context,
                                                        affiliate_page);
                                                  },
                                                ),
                                                visible: snapshot
                                                            .data!
                                                            .data!
                                                            .data!
                                                            .hideAffiliate ==
                                                        "false"
                                                    ? true
                                                    : false,
                                              ); // System Setting Visiblity logged user
                                          }
                                        } else {
                                          return SizedBox();
                                        }
                                      }); // System Setting Visiblity non-logged user
                            case Status.ERROR:
                              ToastHelper.showLong(
                                  "Affiliate not available right now");
                              return SizedBox();
                          }
                        }
                        return SizedBox();
                      }),
                  // MoreMenu(
                  //     title: "Submit your feedback",
                  //     icon: Icons.feedback,
                  //     callback: () {
                  //       Navigator.of(context).pushNamed(feedback_form);
                  //     },
                  //     isLast: false),
                  MoreMenu(
                      title: "About Us",
                      icon: Icons.info,
                      callback: () {
                        Navigator.of(context).pushNamed(about_us);
                      },
                      isLast: true)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserDataResponse> fetchUser() async {
    var response = await http.get(
      Uri.parse("https://demo.mero.school/Api/userdata?auth_token=$fetchToken"),
    );
    var json = jsonDecode(response.body);
    return UserDataResponse.fromJson(json);
  }

  Widget optionMenu(String title, IconData icon, Function callback) {
    return InkWell(
      onTap: () {
        callback.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: HexColor.fromHex(colorBlue),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .apply(color: Colors.black87))
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black12,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _getNumber() async {
    var num = await Preference.getString(phone);

    var alternate = await Preference.getString(phone_alternate);

    if (alternate != null && alternate.isNotEmpty) {
      num = "$num\n$alternate";
    }

    print("$num");

    return num;
  }

  Future<String?> _getEmail() async {
    var num = await Preference.getString(systemEmail);

    return num;
  }

  Future<void> _launchCaller() async {
    var number = await Preference.getString(phone);
    var alternetNumber = await Preference.getString(phone_alternate);

    var url = 'tel://$number';

    List<String> list = [];

    if (number != null && number.isNotEmpty) {
      var alts = number.trim().split("/");
      alts.forEach((element) {
        if (element.isNotEmpty) {
          list.add(element);
        }
      });
    }

    if (alternetNumber != null) {
      var alts = alternetNumber.trim().split("/");

      alts.forEach((element) {
        if (element.isNotEmpty) {
          list.add(element);
        }
      });
    }

    if (list.length > 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Contact us'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: list.map((e) {
                    return ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        url = 'tel:$e';
                        print(url);
                        if (await canLaunch(url)) {
                          try {
                            await launch(url);
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      title: Text(e),
                    );
                  }).toList(),
                ));
          });
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    // var url  = 'tel://+977 1-5320071';
  }

  Future<void> _emailLaunchUri(String s) async {
    //Preference.prefs.getString(systemEmail)

    // var s = await Preference.getString(systemEmail);
    final Uri _emailUri = Uri(
      scheme: 'mailto',
      path: s,
    );
    launch(_emailUri.toString());
  }
}
