import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mero_school/business_login/blocs/login_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:mero_school/data/models/response/login_response.dart';
// import 'package:mero_school/data/models/response/facebook_user_profile.dart';
import 'package:mero_school/data/models/response/social_login_response.dart';
import 'package:mero_school/main.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/app_message_dialog.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;
  late AppProgressDialog _progressDialog;
  late LoginBloc _loginBloc;
  late bool _passwordVisible;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String? password = '';
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Map? _arguments;

  bool showPopup = false;

  AppMessageDialog? appMessageDialog;

  void callBackForLogout(String uid) {}

  @override
  void initState() {
    _passwordVisible = false;
    _loginBloc = LoginBloc();
    super.initState();
    _checkIfIsLogged();
    // _googleSignIn.signOut();
    WebEngagePlugin.trackScreen(TAG_LOGIN);
  }

  Future<void> _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      final userData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  Future<void> _fbLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();

    switch (result.status) {
      case LoginStatus.success:
        _progressDialog.show();
        _accessToken = result.accessToken;
        final userData = await FacebookAuth.instance.getUserData();
        _userData = userData;
        final id = userData['id'];
        final mail = userData['email'];
        final firstName =
            await FacebookAuth.instance.getUserData(fields: 'first_name');
        final lastName =
            await FacebookAuth.instance.getUserData(fields: 'last_name');
        final displayName = firstName['first_name'];
        final familyName = lastName['last_name'];

        _loginBloc.fetchSocialLogin(
            displayName, mail, familyName, id, "facebook");

        break;
      case LoginStatus.cancelled:
        ToastHelper.showShort('Action Cancelled');
        break;

      case LoginStatus.operationInProgress:
        ToastHelper.showShort('Loading');
        _progressDialog.show();
        break;

      case LoginStatus.failed:
        ToastHelper.showShort('Oops something went wrong. Please try again');
        break;
      default:
        break;
    }

    setState(() {
      _checking = false;
    });
  }

  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  Future<void> gmailLogin() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      print(account);

      if (account != null) {
        _progressDialog.show();
        _loginBloc.fetchSocialLogin(
            account.displayName, account.email, empty, account.id, "google");
      }
    } catch (error) {
      print("My error:::$error");
    }
  }

  void displayDialog(String msg, String id) {}

  String? from = "";

  void goBackOrOpenHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = new AppProgressDialog(context);

    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    if (_arguments != null && _arguments!.containsKey('root')) {
      from = _arguments!['root'];
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Visibility(
            visible: (from == "splash" ? true : false),
            child: InkWell(
              onTap: () {
                // Navigator.of(context).pushReplacementNamed(home_page);

                goBackOrOpenHome();
              },
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "SKIP FOR NOW",
                    style: TextStyle(color: Colors.blue),
                  )),
            ),
          )
        ],
        leading: Visibility(
          visible: (from == "splash" ? false : true),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: HexColor.fromHex(bottomNavigationEnabledState)),
              onPressed: () => {goBackOrOpenHome()}),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Image.asset(logo, height: 100, width: 100),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Text(mero_school_login,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: HexColor.fromHex(darkNavyBlue)))),

              Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                      child: Text(
                        entrance_phone_number,
                        style: TextStyle(color: HexColor.fromHex(colorBlue)),
                      ),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return ("This field can't be empty");
                        } else if (value.trim().length != 10) {
                          return ("Mobile Number must be of 10 digit");
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        this.phoneNumber = value!.trim();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: HexColor.fromHex(bottomNavigationIdealState),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor.fromHex(inActive)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                      child: Text(
                        textpassword,
                        style: TextStyle(color: HexColor.fromHex(colorBlue)),
                      ),
                    ),
                    TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key_rounded,
                            color: HexColor.fromHex(bottomNavigationIdealState),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: HexColor.fromHex(inActive)),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState),
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              })),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("This field can't be empty");
                        } else if (value.length <= 5) {
                          return ("Password can't be less than 6 characters");
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        this.password = value;
                      },
                    ),
                  ],
                ),
              ),

              StreamBuilder<Response<LoginResponse>>(
                  stream: _loginBloc.settingDataStream,
                  builder: (context, response) {
                    if (response.hasData) {
                      switch (response.data!.status) {
                        case Status.LOADING:
                          debugPrint("Status.LOADING");
                          //Loading(loadingMessage: snapshot.data.message);
                          return _loginWidget(context);
                        case Status.SUCCESS:
                          _progressDialog.hide();
                          ToastHelper.showErrorLong(
                              "" + response.data!.message!);
                          // _progressDialog.hide();
                          return _loginWidget(context);
                        case Status.COMPLETED:
                          _progressDialog.hide();
                          if (response.data!.data!.data!.validity == 1) {
                            print("==validity 1 ma xiro");
                            // Provider.of<UserStateViewModel>(context, listen: false).updateCurrentLoginStatus(response.data.data.data.token);
                            _loginBloc.saveData(response.data!.data!, context);
                            analytics.logEvent(
                                name: LOGIN,
                                parameters: <String, String>{METHOD: 'phone'});
                            // print("==redirection==>"+ _arguments['isPreviousPage']);
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => {
                                      _progressDialog.hide().then((value) => {
                                            continueToNextPage(
                                                response
                                                    .data!.data!.data!.token,
                                                from)
                                          })
                                    });
                          } else if (response.data!.data!.data!.validity == 4) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              var appMessageDialog = new AppMessageDialog(
                                  context, callback: (uid) {
                                _loginBloc.fetchLogout(uid);
                              }, action: "Logout EveryWhere");

                              appMessageDialog.show(
                                  "${response.data!.data!.message}",
                                  response.data!.data!.data!.userId,
                                  "Logout Every Where");
                            });

                            // displayDialog("${response.data.data.message}", response.data.data.data.userId);

                          } else {
                            print("==validity else ma xiro");

                            ToastHelper.showErrorLong(
                                "Invalid username/password supplied");
                          }
                          // _splashBloc.saveData(snapshot.data.data,context);
                          debugPrint("Status.COMPLETED progress bar");
                          // callDashboard();

                          return _loginWidget(context);

                          // return mainView(displayJoke: snapshot.data.data);
                          break;
                        case Status.ERROR:
                          debugPrint("Status.ERROR");
                          _progressDialog.hide();
                          ToastHelper.showErrorLong(response.data!.message!);
                          return _loginWidget(context);

                        // return Error(
                        //   errorMessage: snapshot.data.message,
                        //   onRetryPressed: () => _splashBloc.fetchSystemSettings(),
                        // );
                        default:
                          return _loginWidget(context);
                      }
                    } else {
                      return _loginWidget(context);
                    }
                  }),
              Container(
                margin: EdgeInsets.fromLTRB(0, 16, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      forget_password,
                      style: TextStyle(color: HexColor.fromHex(colorSpindle)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, change_password_page);
                      },
                      child: Text(
                        reset,
                        style: TextStyle(color: HexColor.fromHex(colorBlue)),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 24, 30, 0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(color: HexColor.fromHex(colorSpindle))),
                    Text(continue_with,
                        style:
                            TextStyle(color: HexColor.fromHex(colorSpindle))),
                    Expanded(
                        child: Divider(color: HexColor.fromHex(colorSpindle))),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(30, 24, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<Response<SocialLoginResponse>>(
                        stream: _loginBloc.settingDataStreamSocial,
                        builder: (context, response) {
                          if (response.hasData) {
                            switch (response.data!.status) {
                              case Status.LOADING:
                                debugPrint("Status.LOADING");
                                //Loading(loadingMessage: snapshot.data.message);
                                return socialLoginButtonWidget();

                              case Status.COMPLETED:
                                if (response.data!.data!.data!.validity == 1) {
                                  _loginBloc.saveDataSocial(
                                      response.data!.data!, context);

                                  // Preference.setString(
                                  //     token, response.data.data.data.token);
                                  //
                                  //
                                  // Preference.setString(user_token, response.data.data.data.token);
                                  // print(
                                  //     "==savingUserId: ${response.data.data.data.userId}");
                                  // Preference.setString(
                                  //     user_id, response.data.data.data.userId.toString());

                                  // _googleSignIn.signOut();

                                  // print("==redirection==>"+ _arguments['isPreviousPage']);

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) => {
                                            _progressDialog.hide().then(
                                                (value) => {
                                                      continueToNextPage(
                                                          response.data!.data!
                                                              .data!.token,
                                                          from)
                                                    })
                                          });
                                } else if (response
                                        .data!.data!.data!.validity ==
                                    4) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    var appMessageDialog = new AppMessageDialog(
                                        context, callback: (uid) {
                                      _loginBloc.fetchLogout(uid);
                                    }, action: "Logout EveryWhere");

                                    appMessageDialog.show(
                                        "${response.data!.data!.message}",
                                        response.data!.data!.data!.userId,
                                        "Logout Every Where");
                                  });

                                  // displayDialog("${response.data.data.message}", response.data.data.data.userId);

                                } else {
                                  ToastHelper.showErrorLong("Please try again");
                                }

                                // _progressDialog.hide();

                                return socialLoginButtonWidget();

                              // return mainView(displayJoke: snapshot.data.data);
                              case Status.ERROR:
                                debugPrint("Status.ERROR");
                                _progressDialog.hide();
                                ToastHelper.showErrorLong(
                                    response.data!.message!);
                                return socialLoginButtonWidget();

                              // return Error(
                              //   errorMessage: snapshot.data.message,
                              //   onRetryPressed: () => _splashBloc.fetchSystemSettings(),
                              // );
                              default:
                                return socialLoginButtonWidget();
                            }
                          } else {
                            return socialLoginButtonWidget();
                          }
                        }),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      need_create_account,
                      style: TextStyle(color: HexColor.fromHex(colorSpindle)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(register_page);

                        // Navigator.pushNamed(context, register_page);
                      },
                      child: Text(
                        register.toUpperCase(),
                        style: TextStyle(color: HexColor.fromHex(colorBlue)),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, bottom: 16.0, left: 32.0, right: 32.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'By signing Up, you agree with Mero School\'s '),
                      TextSpan(
                          text: 'Terms.',
                          style:
                              TextStyle(color: HexColor.fromHex(colorAccent)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Terms of Service"');

                              Navigator.of(context).pushNamed(
                                  smart_payment_page,
                                  arguments: <String, String>{
                                    'paymentUrl':
                                        'https://mero.school/terms_and_condition'
                                  });
                            }),
                      TextSpan(text: ' Learn how we process your data in our '),
                      TextSpan(
                          text: 'Privacy Policy',
                          style:
                              TextStyle(color: HexColor.fromHex(colorAccent)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushNamed(
                                  smart_payment_page,
                                  arguments: <String, String>{
                                    // 'paymentUrl': 'intent://callback?ABSDSX#Intent;package=school.mero.lms;scheme=signinwithapple;end'
                                    'paymentUrl':
                                        'https://mero.school/privacy_policy'
                                  });
                              print('Privacy Policy"');
                            }),
                    ],
                  ),
                ),
              )
              //
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  Widget _loginWidget(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.fromLTRB(30, 16, 30, 0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: HexColor.fromHex(colorBlue),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              login,
              style: TextStyle(fontSize: 18),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _loginBloc.fetchLogin(phoneNumber, password);
              _progressDialog.show();
            }
          }),
    );
  }

  Future<void> appleLogin() async {
    //appleLogin'''

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId: 'school.mero.app',
        redirectUri: Uri.parse(
          // 'https://rigorous-courageous-potassium.glitch.me/callbacks/sign_in_with_apple',
          'https://af90-27-34-53-71.ngrok.io/callbacks/sign_in_with_apple',
        ),
      ),
    );
    print("--reached hererrequeting");

    //

    //
    print(credential.toString());
    print(credential.authorizationCode);

    _progressDialog.show();

    print("---social login requesting...");

    _loginBloc.fetchSocialLogin("${credential.givenName}", credential.email,
        "${credential.familyName}", credential.userIdentifier, "apple");
  }

  Widget socialLoginButtonWidget() {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(minimumSize: Size(250, 40)),
          onPressed: () {
            _fbLogin();
          },
          icon: Image.asset(
            "assets/facebook.png",
            height: 20,
            color: Colors.white,
          ),
          label: Text("Continue with Facebook"),
        ),
        // SignInButton(
        //   Buttons.Facebook,
        //   onPressed: () {
        //     _fbLogin();
        //   },
        // ),
        SizedBox(
          height: 5,
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, minimumSize: Size(250, 40)),
          onPressed: () {
            gmailLogin();
          },
          icon: Image.asset(
            "assets/google.png",
            height: 20,
            // color: Colors.transparent,
          ),
          label: Text(
            "Continue with Google",
            style: TextStyle(color: Colors.black),
          ),
        ),
        // SignInButton(Buttons.Google, onPressed: () {
        //   gmailLogin();
        // }),
        SizedBox(
          height: 8,
        ),
        (Platform.isIOS)
            ? Container(
                width: 275,
                child: SignInWithAppleButton(
                  onPressed: () {
                    appleLogin();
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  void continueToNextPage(String? token, String? from) {
    Provider.of<UserStateViewModel>(context, listen: false).update(token);
    if (from == 'splash') {
      Navigator.of(context).pushReplacementNamed(home_page);
    } else {
      Navigator.of(context).pop();
    }
  }
}
