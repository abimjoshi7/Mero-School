import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mero_school/business_login/blocs/register_bloc.dart';
import 'package:mero_school/data/models/response/registration_response.dart';
import 'package:mero_school/data/models/response/social_login_response.dart';
import 'package:mero_school/main.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../../../business_login/blocs/login_bloc.dart';
import '../../../../business_login/user_state_view_model.dart';
import '../../../../utils/app_message_dialog.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken; //for facebook
  bool _checking = true;
  late AppProgressDialog _progressDialog;
  late LoginBloc _loginBloc;
  late bool _passwordVisible;
  late RegisterBloc _registerBloc;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? phoneNumber = '';
  String? password = '';
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Map? _arguments;

  @override
  void initState() {
    _loginBloc = LoginBloc();
    _passwordVisible = false;
    _registerBloc = RegisterBloc();
    _checkIfIsLogged();
    super.initState();
    WebEngagePlugin.trackScreen(TAG_LOGIN);

    // _googleSignIn.signOut();
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

      case LoginStatus.failed:
        ToastHelper.showShort('Oops someting went wrong. Please try again');
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
          leading: Visibility(
            visible: (from == "splash" ? false : true),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: HexColor.fromHex(bottomNavigationEnabledState)),
                onPressed: () {
                  goBackOrOpenHome();
                  // print(_arguments);
                }),
          )
          // )
          ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Image.asset(logo, height: 100, width: 100),
              ), // logo
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Text(mero_school_register,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: HexColor.fromHex(darkNavyBlue)))),
              Container(
                margin: EdgeInsets.all(30),
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
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("This field can't be empty");
                        } else if (value.length != 10) {
                          return ("Mobile Number must be of 10 digit");
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        this.phoneNumber = value;
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
              StreamBuilder<Response<RegistrationResponse>>(
                  stream: _registerBloc.dataStream,
                  builder: (context, response) {
                    if (response.hasData) {
                      switch (response.data!.status) {
                        case Status.LOADING:
                          debugPrint("Status.LOADING");
                          //Loading(loadingMessage: snapshot.data.message);
                          return _registerWidget();
                        case Status.COMPLETED:
                          _progressDialog.hide();
                          ToastHelper.showLong(response.data!.data!.message!);
                          analytics.logEvent(
                              name: SIGN_UP,
                              parameters: <String, String>{METHOD: 'phone'});

                          WebEngagePlugin.trackEvent(
                              TAG_SIGN_UP, <String, String>{
                            'Sign Up Method': 'phone',
                            'Sign Up Mode': 'app'
                          });

                          Preference.setString("temp_number", phoneNumber);

                          // Navigator.pushNamed(context, verify_otp,
                          //     arguments: <String, String?>{
                          //       'phoneNumber': phoneNumber,
                          //       'message': "Requesting OTP"
                          //     });

                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pushNamed(context, verify_otp,
                                arguments: <String, String?>{
                                  'phoneNumber': phoneNumber,
                                });
                          });

                          // debugPrint("Status.COMPLETED progress bar");
                          // callDashboard();
                          return _registerWidget();
                        case Status.ERROR:
                          debugPrint("Status.ERROR");
                          _progressDialog.hide();
                          ToastHelper.showErrorLong(response.data!.message!);
                          return _registerWidget();

                        default:
                          return _registerWidget();
                      }
                    } else {
                      return _registerWidget();
                    }
                  }),

              Container(
                margin: EdgeInsets.fromLTRB(0, 24, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      already_got_otp,
                      style: TextStyle(color: HexColor.fromHex(colorSpindle)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, verify_otp,
                            arguments: <String, String?>{
                              'phoneNumber': phoneNumber,
                            });
                      },
                      child: Text(
                        enter_otp,
                        style: TextStyle(color: HexColor.fromHex(colorBlue)),
                      ),
                    )
                  ],
                ),
              ), //OTP
              Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
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
              ), //Divider Design
              Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                                                          from!)
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
                      already_have_account,
                      style: TextStyle(color: HexColor.fromHex(colorSpindle)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, login_page,
                            arguments: <String, String>{'root': 'splash'});
                      },
                      child: Text(
                        login.toUpperCase(),
                        style: TextStyle(color: HexColor.fromHex(colorBlue)),
                      ),
                    )
                  ],
                ),
              ), //
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

  Widget _registerWidget() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.fromLTRB(30, 24, 30, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: HexColor.fromHex(colorBlue),
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
            _registerBloc.updatePassword(phoneNumber, password);
            _progressDialog.show();
          }
        },
      ),
    );
  }

  Future<Null> appleLogin() async {
    //appleLogin
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
    _progressDialog.show();
    _registerBloc.fetchSocialLogin("${credential.givenName}", credential.email,
        "${credential.familyName}", "", credential.userIdentifier!, "apple");
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

  // Widget socialLoginButtonWidget() {
  //   return Column(
  //     children: [
  //       SignInButton(
  //         Buttons.FacebookNew,
  //         onPressed: () {
  //           _fbLogin();
  //         },
  //       ),
  //       SizedBox(
  //         height: 5,
  //       ),
  //       SignInButton(Buttons.Google, onPressed: () {
  //         gmailLogin();
  //       }),
  //       SizedBox(
  //         height: 8,
  //       ),
  //       (Platform.isIOS)
  //           ? Container(
  //               width: 275,
  //               child: SignInWithAppleButton(
  //                 onPressed: () {
  //                   appleLogin();
  //                 },
  //               ),
  //             )
  //           : Container(),
  //     ],
  //   );
  // }

  void continueToNextPage(String? token, String from) {
    Provider.of<UserStateViewModel>(context, listen: false).update(token);

    Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
  }
}
