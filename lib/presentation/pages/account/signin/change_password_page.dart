import 'package:flutter/material.dart';
import 'package:mero_school/business_login/blocs/change_password_bloc.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/data/models/response/reset_passwod_response.dart';
import 'package:mero_school/data/models/response/reset_response.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late bool _passwordVisible;
  bool? _checkbox;
  late AppProgressDialog _progressDialog;
  late ChangePasswordBloc _changePasswordBloc;
  GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyOther = GlobalKey<FormState>();
  String? phoneNumber = '';
  String? otpNumber = '';
  String? password = '';

  @override
  void initState() {
    _passwordVisible = false;
    _checkbox = false;
    _changePasswordBloc = ChangePasswordBloc();
    _progressDialog = new AppProgressDialog(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
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
                  Form(
                    key: _formKeyPhone,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: HexColor.fromHex(bottomNavigationIdealState),
                        ),
                      ),
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
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKeyOther,
              child: Column(
                children: [
                  Visibility(
                    visible: _checkbox!,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(
                              otp_number,
                              style:
                                  TextStyle(color: HexColor.fromHex(colorBlue)),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("This field can't be empty");
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              this.otpNumber = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _checkbox!,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(
                              textpassword,
                              style:
                                  TextStyle(color: HexColor.fromHex(colorBlue)),
                            ),
                          ),
                          TextFormField(
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key_rounded,
                                  color: HexColor.fromHex(
                                      bottomNavigationIdealState),
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
                  ),
                ],
              ),
            ),
            Container(
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  already_got_otp_to_reset,
                  style: TextStyle(color: HexColor.fromHex(colorBlue)),
                ),
                value: _checkbox,
                onChanged: (bool? value) {
                  setState(() {
                    _checkbox = value;
                  });
                },
              ),
            ),
            _checkbox!
                ? StreamBuilder<Response<ResetResponse>>(
                    stream: _changePasswordBloc.dataStreamReset,
                    builder: (context, response) {
                      if (response.hasData) {
                        switch (response.data!.status) {
                          case Status.LOADING:
                            debugPrint("Status.LOADING");
                            //Loading(loadingMessage: snapshot.data.message);
                            return _changePasswordButton();
                            break;
                          case Status.COMPLETED:
                            _progressDialog.hide();
                            //please asked niraj bro
                            ToastHelper.showLong(response.data!.data!.message!);

                            Future.delayed(Duration.zero, () {
                              // Navigator.pushReplacementNamed(
                              //     context, login_page);

                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, login_page);
                              }
                            });
                            debugPrint("Status.COMPLETED progress bar");
                            // callDashboard();

                            return _changePasswordButton();

                            // return mainView(displayJoke: snapshot.data.data);
                            break;
                          case Status.ERROR:
                            debugPrint("Status.ERROR");
                            _progressDialog.hide();

                            ToastHelper.showErrorLong(response.data!.message!);
                            return _changePasswordButton();

                            // return Error(
                            //   errorMessage: snapshot.data.message,
                            //   onRetryPressed: () => _splashBloc.fetchSystemSettings(),
                            // );
                            break;
                          default:
                            return _changePasswordButton();
                        }
                      } else {
                        return _changePasswordButton();
                      }
                    })
                : StreamBuilder<Response<ResetPasswodResponse>>(
                    stream: _changePasswordBloc.dataStream,
                    builder: (context, response) {
                      if (response.hasData) {
                        switch (response.data!.status) {
                          case Status.LOADING:
                            debugPrint("Status.LOADING");
                            //Loading(loadingMessage: snapshot.data.message);
                            return _changePasswordButton();
                            break;
                          case Status.COMPLETED:
                            _progressDialog.hide();
                            ToastHelper.showLong(response.data!.data!.message!);
                            Future.delayed(Duration.zero, () {
                              setState(() {
                                _checkbox = true;
                              });
                            });

                            // Future.delayed(Duration.zero, () {
                            //   Navigator.pushReplacementNamed(context, login_page);
                            // });
                            debugPrint("Status.COMPLETED progress bar");
                            // callDashboard();

                            return _changePasswordButton();

                            // return mainView(displayJoke: snapshot.data.data);
                            break;
                          case Status.ERROR:
                            debugPrint("Status.ERROR");
                            _progressDialog.hide();

                            ToastHelper.showErrorLong(response.data!.message!);
                            return _changePasswordButton();

                            // return Error(
                            //   errorMessage: snapshot.data.message,
                            //   onRetryPressed: () => _splashBloc.fetchSystemSettings(),
                            // );
                            break;
                          default:
                            return _changePasswordButton();
                        }
                      } else {
                        return _changePasswordButton();
                      }
                    }),

            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    already_have_account,
                    style: TextStyle(color: HexColor.fromHex(colorSpindle)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.popAndPushNamed(context, login_page);
                    },
                    child: Text(
                      login.toUpperCase(),
                      style: TextStyle(color: HexColor.fromHex(colorBlue)),
                    ),
                  )
                ],
              ),
            )

            //
          ],
        ),
      ),
    );
  }

  Widget _changePasswordButton() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: HexColor.fromHex(colorBlue),
        ),
        child: _checkbox! ? Text(textchange_password) : Text("Request Change"),
        onPressed: () {
          if (_checkbox!) {
            if (_formKeyPhone.currentState!.validate()) {
              _formKeyPhone.currentState!.save();
              if (_formKeyOther.currentState!.validate()) {
                _formKeyOther.currentState!.save();
                //reset/9843641510 api
                _changePasswordBloc.reset(phoneNumber, password, otpNumber);
                _progressDialog.show();
              }
            }
          } else {
            if (_formKeyPhone.currentState!.validate()) {
              _formKeyPhone.currentState!.save();
              _changePasswordBloc.changePassword(phoneNumber);
              _progressDialog.show();
            }
          }
        },
      ),
    );
  }
}
