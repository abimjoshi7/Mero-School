import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http/http.dart' as http;
import 'package:mero_school/business_login/blocs/login_bloc.dart';
import 'package:mero_school/business_login/blocs/user_data_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../../../business_login/blocs/register_bloc.dart';
import '../../../../data/models/response/registration_response.dart';
import '../../../../data/models/response/user_data_response.dart';
import '../../../../main.dart';
import '../../../../networking/Response.dart';
import '../../../../utils/extension_utils.dart';
import '../../../../utils/preference.dart';
import '../../../../utils/toast_helper.dart';
import '../../../../webengage/tags.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../constants/route.dart';
import '../../../constants/strings.dart';

class CreateAffiliate extends StatefulWidget {
  const CreateAffiliate({Key? key}) : super(key: key);

  @override
  State<CreateAffiliate> createState() => _CreateAffiliateState();
}

class _CreateAffiliateState extends State<CreateAffiliate> {
  late UserDataBloc _userDataBloc;
  late LoginBloc _loginBloc;
  late bool _passwordVisible;
  late RegisterBloc _registerBloc;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? userEmail;
  String? phoneNumber;
  String? youtubeChannel;
  String? website;
  String? promoteReason;
  String? socialChannel;
  String? affiliatePassword;
  bool isUserLogged = false;
  String? fetchToken;

  @override
  void initState() {
    super.initState();
    _userDataBloc = UserDataBloc();
    _userDataBloc.initBloc();
    _loginBloc = LoginBloc();
    _registerBloc = RegisterBloc();
    WebEngagePlugin.trackScreen(TAG_LOGIN);
  }

  String? from = "";

  void goBackOrOpenHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchToken = Provider.of<UserStateViewModel>(context).loginToken;
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  Future<SharedPreferences> getPref() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          // TextButton(
          //     onPressed: () async {
          //       final preferences = await SharedPreferences.getInstance();
          //       final qwe = preferences.getString(profile_completed_status);
          //       // print("HI");
          //       if (qwe == '1') {
          //         print(1);
          //       } else {
          //         print(0);
          //       }
          //       // final x = await _userDataBloc.fetchData();
          //       // print("QWE:" + x);
          //       print(qwe.runtimeType);
          //     },
          //     child: Text("test")),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<SharedPreferences>(
              future: getPref(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          affiliate_registration_form,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: HexColor.fromHex(darkNavyBlue),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      fetchToken!.isNotEmpty
                          ? FutureBuilder<UserDataResponse>(
                              future: fetchUser(),
                              builder: (_, response) {
                                if (response.hasData) {
                                  switch (
                                      response.data!.data!.affiliateStatus) {
                                    case "non-affiliate":
                                      return Column(
                                        children: [
                                          getBasicInformation(snapshot.data!),
                                          StreamBuilder<
                                                  Response<
                                                      RegistrationResponse>>(
                                              stream: _registerBloc.dataStream,
                                              builder: (context, response) {
                                                if (response.hasData) {
                                                  switch (
                                                      response.data!.status) {
                                                    case Status.LOADING:
                                                      debugPrint(
                                                          "Status.LOADING");
                                                      return _registerWidget();
                                                    case Status.COMPLETED:
                                                      ToastHelper.showLong(
                                                          response.data!.data!
                                                              .message!);
                                                      analytics.logEvent(
                                                          name: SIGN_UP,
                                                          parameters: <String,
                                                              String>{
                                                            METHOD: 'phone'
                                                          });

                                                      WebEngagePlugin
                                                          .trackEvent(
                                                              TAG_SIGN_UP,
                                                              <String, String>{
                                                            'Sign Up Method':
                                                                'affiliate',
                                                            'Sign Up Mode':
                                                                'app'
                                                          });

                                                      Preference.setString(
                                                          "temp_number",
                                                          phoneNumber);

                                                      Future.delayed(
                                                          Duration.zero, () {
                                                        Navigator.pushNamed(
                                                            context, verify_otp,
                                                            arguments: <String,
                                                                String?>{
                                                              'phoneNumber':
                                                                  phoneNumber,
                                                            });
                                                      });

                                                      debugPrint(
                                                          "Status.COMPLETED progress bar");
                                                      // callDashboard();
                                                      return _registerWidget();

                                                    case Status.ERROR:
                                                      debugPrint(
                                                          "Status.ERROR");
                                                      ToastHelper.showErrorLong(
                                                          response
                                                              .data!.message!);
                                                      return _registerWidget();

                                                    default:
                                                      return _registerWidget();
                                                  }
                                                } else {
                                                  return _registerWidget();
                                                }
                                              }),
                                        ],
                                      );
                                    default:
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              response.data!.data!
                                                  .affiliateMessage!,
                                              style: TextStyle(
                                                  color: Colors.red.shade300,
                                                  fontSize: 17),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                  }
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              })
                          : Column(
                              children: [
                                getBasicInformation(snapshot.data!),
                                StreamBuilder<Response<RegistrationResponse>>(
                                    stream: _registerBloc.dataStream,
                                    builder: (context, response) {
                                      if (response.hasData) {
                                        switch (response.data!.status) {
                                          case Status.LOADING:
                                            debugPrint("Status.LOADING");
                                            return _registerWidget();
                                          case Status.COMPLETED:
                                            ToastHelper.showLong(
                                                response.data!.data!.message!);
                                            analytics.logEvent(
                                                name: SIGN_UP,
                                                parameters: <String, String>{
                                                  METHOD: 'phone'
                                                });

                                            WebEngagePlugin.trackEvent(
                                                TAG_SIGN_UP, <String, String>{
                                              'Sign Up Method': 'affiliate',
                                              'Sign Up Mode': 'app'
                                            });

                                            Preference.setString(
                                                "temp_number", phoneNumber);

                                            Future.delayed(Duration.zero, () {
                                              Navigator.pushNamed(
                                                  context, verify_otp,
                                                  arguments: <String, String?>{
                                                    'phoneNumber': phoneNumber,
                                                  });
                                            });

                                            debugPrint(
                                                "Status.COMPLETED progress bar");
                                            return _registerWidget();

                                          case Status.ERROR:
                                            debugPrint("Status.ERROR");
                                            ToastHelper.showErrorLong(
                                                response.data!.message!);
                                            return _registerWidget();

                                          default:
                                            return _registerWidget();
                                        }
                                      } else {
                                        return _registerWidget();
                                      }
                                    }),
                              ],
                            ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }

  Widget getBasicInformation(SharedPreferences pref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(children: [
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  initialValue: pref.getString(first_name) == null ||
                          pref.getString(profile_completed_status) != "1"
                      ? ""
                      : "${pref.getString(first_name)}",
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.account_circle_rounded),
                  ),
                  onSaved: (String? value) {
                    firstName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: TextFormField(
                  initialValue: pref.getString(last_name) == null ||
                          pref.getString(profile_completed_status) != "1"
                      ? ""
                      : "${pref.getString(last_name)}",
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.account_circle_rounded),
                  ),
                  onSaved: (String? value) {
                    lastName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          TextFormField(
            initialValue: pref.getString(user_email) == null ||
                    pref.getString(user_email)!.contains("@mero.school") == true
                ? ""
                : "${pref.getString(user_email)}",
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_rounded),
            ),
            onSaved: (String? value) {
              userEmail = value;
            },
            validator: (value) {
              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value!);
              if (value.isEmpty) {
                return ("This field can't be empty");
              } else if (!emailValid) {
                return ("Your Email Id is Invalid.");
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: pref.getString(phone_number) == null
                ? ""
                : "${pref.getString(phone_number)}",
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
            ),
            onSaved: (String? value) {
              phoneNumber = value;
            },
            validator: (value) {
              bool phoneValid = value!.length > 8;
              if (value.isEmpty) {
                return ("This field can't be empty");
              } else if (!phoneValid) {
                return ("Phone is invalid.");
              }
              return null;
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "eg:https://www.youtube/yourchannel",
              labelText: 'Youtube Channel(optional)',
              prefixIcon: Icon(FontAwesome.youtube_play),
            ),
            onSaved: (String? value) {
              youtubeChannel = value;
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "eg:https://mero.school/",
              labelText: 'Website(optional)',
              prefixIcon: Icon(FontAwesome.chrome),
            ),
            onSaved: (String? value) {
              website = value;
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'How will you promote us?',
              prefixIcon: Icon(Icons.question_mark_rounded),
            ),
            onSaved: (String? value) {
              promoteReason = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }

              return null;
            },
          ),
          TextFormField(
            // textInputAction: TextInputAction.next,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintMaxLines: 3,
              labelText: 'Social Media Channel',
              prefixIcon: Icon(
                Icons.interests_outlined,
              ),
            ),
            onSaved: (String? value) {
              socialChannel = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          fetchToken!.isNotEmpty
              ? SizedBox()
              : Column(
                  children: [
                    TextFormField(
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintMaxLines: 3,
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.key_rounded,
                          color: HexColor.fromHex(bottomNavigationIdealState),
                        ),
                      ),
                      onSaved: (String? value) {
                        affiliatePassword = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value.length < 8) {
                          return "Password must be greater than 8 letters.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintMaxLines: 3,
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(
                          Icons.key_rounded,
                          color: HexColor.fromHex(bottomNavigationIdealState),
                        ),
                      ),
                      onSaved: (String? value) {
                        affiliatePassword = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value.length < 8) {
                          return "Password must be greater than 8 letters.";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget _registerWidget() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.fromLTRB(30, 24, 30, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: HexColor.fromHex(colorBlue),
          textStyle: TextStyle(color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            register,
            style: TextStyle(fontSize: 18),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if (fetchToken!.isNotEmpty) {
              postAffiliateForm();
              print('token bearer');
            } else {
              postAffiliateForm();
              print("no token");
            }
          }
        },
      ),
    );
  }

  Future<void> postAffiliateForm() async {
    final response = await http.post(
        Uri.parse("https://demo.mero.school/Apiv2/affiliatesRegistration"),
        body: {
          "first_name": "$firstName",
          "last_name": "$lastName",
          "email": "$userEmail",
          "phone_number": "$phoneNumber",
          "youtube_channel": "$youtubeChannel",
          "social_media_channel": "$socialChannel",
          "website": "$website",
          "reason_promote": "$promoteReason",
          "password": fetchToken!.isEmpty ? "$affiliatePassword" : "",
          "confirm_password": fetchToken!.isEmpty ? "$affiliatePassword" : "",
          "user_from": "app",
          "auth_token": fetchToken ?? ""
        });

    print(response.body);

    if (response.statusCode == 200) {
      if (fetchToken!.isEmpty) {
        Navigator.pushNamed(context, verify_otp, arguments: <String, String?>{
          'phoneNumber': phoneNumber,
          'message': response.body
        });
      } else {
        Navigator.pop(context);
      }
    } else {
      ToastHelper.showLong(response.body);
    }
    // }
  }

  Future<UserDataResponse> fetchUser() async {
    var response = await http.get(
      Uri.parse("https://demo.mero.school/Api/userdata?auth_token=$fetchToken"),
    );
    var json = jsonDecode(response.body);
    return UserDataResponse.fromJson(json);
  }
}
