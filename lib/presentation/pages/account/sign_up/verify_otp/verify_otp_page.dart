import 'package:flutter/material.dart';
import 'package:mero_school/business_login/blocs/login_bloc.dart';
import 'package:mero_school/business_login/blocs/otp_verification_bloc.dart';
import 'package:mero_school/data/models/response/login_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/app_message_dialog.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:provider/provider.dart';

import '../../../../../business_login/user_state_view_model.dart';

class VerifyOtpPage extends StatefulWidget {
  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  String _smsCode = "";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? otpCode = '';
  String? phoneNumber = '';
  String? message;
  late OTPVerificationBloc _otpVerificationBloc;
  late AppProgressDialog _progressDialog;

  late LoginBloc _loginBloc;

  @override
  void initState() {
    _otpVerificationBloc = OTPVerificationBloc();
    _loginBloc = LoginBloc();
    _otpVerificationBloc.optStartListening();
    _otpVerificationBloc.optHashKey();
    _progressDialog = new AppProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map? _arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    if (_arguments != null && _arguments.containsKey("phoneNumber")) {
      phoneNumber = _arguments['phoneNumber'];
      message = _arguments['message'];
    }

    return StreamBuilder<String>(
        stream: _otpVerificationBloc.otpStream,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            otpCode = snapshot.data;
          }

          print("otpCode: $otpCode");

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: HexColor.fromHex(bottomNavigationEnabledState)),
                onPressed: () => Navigator.of(context).pop(),
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
                        child: Text(app_name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
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
                              style:
                                  TextStyle(color: HexColor.fromHex(colorBlue)),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                            initialValue: phoneNumber,
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
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState),
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
                              "OTP Number",
                              style:
                                  TextStyle(color: HexColor.fromHex(colorBlue)),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                            initialValue: otpCode,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("This field can't be empty");
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              this.otpCode = value;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.all_inclusive_rounded,
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<Response<LoginResponse>>(
                        stream: _otpVerificationBloc.dataStream,
                        builder: (context, response) {
                          if (response.hasData) {
                            switch (response.data!.status) {
                              case Status.LOADING:
                                debugPrint("Status.LOADING");
                                //Loading(loadingMessage: snapshot.data.message);
                                return _verifyOtp();
                              case Status.COMPLETED:
                                _progressDialog.hide();
                                if (response.data!.data!.data!.validity == 1) {
                                  print("==validity 1 ma xiro");

                                  // Provider.of<UserStateViewModel>(context, listen: false).updateCurrentLoginStatus(response.data.data.data.token);

                                  _loginBloc.saveData(
                                      response.data!.data!, context);

                                  // print("==redirection==>"+ _arguments['isPreviousPage']);

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) => {
                                            _progressDialog.hide().then(
                                                (value) => {
                                                      continueToNextPage(
                                                          response.data!.data!
                                                              .data!.token,
                                                          'home')
                                                    })
                                          });

                                  // Future.delayed(Duration.zero, () {
                                  //   if(_arguments!=null && _arguments['isPreviousPage']!=null && _arguments['isPreviousPage']){
                                  //     Navigator.of(context).pop();
                                  //   }else{
                                  //     Navigator.of(context)
                                  //         .pushReplacementNamed(home_page);
                                  //   }
                                  //
                                  //
                                  // });

                                  // _loginBloc.callDashboard(context);
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
                                  print("==validity else ma xiro");

                                  ToastHelper.showErrorLong(
                                      "Invalid username/password supplied");
                                }
                                // _splashBloc.saveData(snapshot.data.data,context);
                                debugPrint("Status.COMPLETED progress bar");
                                // callDashboard();

                                // callDashboard();
                                return _verifyOtp();

                                // return mainView(displayJoke: snapshot.data.data);
                                break;
                              case Status.ERROR:
                                debugPrint("Status.ERROR $response");
                                _progressDialog.hide();
                                ToastHelper.showErrorLong(
                                    response.data!.message!);
                                return _verifyOtp();

                              default:
                                return _verifyOtp();
                            }
                          } else {
                            return _verifyOtp();
                          }
                        }),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Need Resent OTP ? ",
                            style: TextStyle(
                                color: HexColor.fromHex(colorSpindle)),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, register_page);
                            },
                            child: Text(
                              "REGISTER",
                              style:
                                  TextStyle(color: HexColor.fromHex(colorBlue)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _verifyOtp() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: ElevatedButton(
        child: Text("Verify OTP"),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _otpVerificationBloc.oTPVerification(phoneNumber, otpCode);
            _progressDialog.show();
          }
        },
      ),
    );
  }

  void continueToNextPage(String? token, String from) {
    Provider.of<UserStateViewModel>(context, listen: false).update(token);
    Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false,
        arguments: <String, String>{'root': 'splash'});
  }
}
