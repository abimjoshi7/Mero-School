import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/business_login/blocs/update_password_bloc.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/data/models/response/update_password_response.dart';
import 'package:mero_school/utils/toast_helper.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? currentPassword = '';
  String? newPassword = '';
  late UpdatePasswordBloc _updatePasswordBloc;
  late AppProgressDialog _progressDialog;
  bool _currentPasswordObscureText = true;
  bool _newPasswordObscureText = true;

  @override
  void initState() {
    _updatePasswordBloc = UpdatePasswordBloc();
    _progressDialog = new AppProgressDialog(context);

    super.initState();
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
      ),
      body: StreamBuilder<Response<UpdatePasswordResponse>>(
          stream: _updatePasswordBloc.dataStream,
          builder: (context, response) {
            if (response.hasData) {
              switch (response.data!.status) {
                case Status.LOADING:
                  debugPrint("Status.LOADING");
                  //Loading(loadingMessage: snapshot.data.message);
                  return _mainView();
                  break;
                case Status.COMPLETED:
                  _progressDialog.hide();
                  // _splashBloc.saveData(snapshot.data.data,context);
                  debugPrint("Status.COMPLETED progress bar");
                  // callDashboard();
                  ToastHelper.showLong(response.data!.data!.message!);
                  _formKey.currentState!.reset();

                  return _mainView();

                  // return mainView(displayJoke: snapshot.data.data);
                  break;
                case Status.ERROR:
                  debugPrint("Status.ERROR ${response.data!.data}");
                  _progressDialog.hide();

                  // if (response.data.data.status == false) {
                  //   ToastHelper.showErrorLong(response.data.message);
                  // } else {
                  // }
                  ToastHelper.showErrorLong(response.data!.message!);

                  return _mainView();

                  // return Error(
                  //   errorMessage: snapshot.data.message,
                  //   onRetryPressed: () => _splashBloc.fetchSystemSettings(),
                  // );
                  break;
                default:
                  return _mainView();
              }
            } else {
              return _mainView();
            }
          }),
    );
  }

  Widget _mainView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Update Password",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .apply(color: Colors.black87),
              ),
              SizedBox(
                height: 32,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Text("Current Password",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .apply(color: HexColor.fromHex(colorBlue))),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style: TextStyle(
                        color: HexColor.fromHex(bottomNavigationIdealState)),
                    obscureText: _currentPasswordObscureText,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("This field can't be empty");
                      } else if (value.length <= 5) {
                        return ("Password can't be less than 6 characters");
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      this.currentPassword = value;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Foundation.key,
                            color: HexColor.fromHex(colorBlue)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _currentPasswordObscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: HexColor.fromHex(colorBlue),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentPasswordObscureText =
                                  !_currentPasswordObscureText;
                            });
                          },
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: HexColor.fromHex(colorBlue)))
                        // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.red))
                        ),

                    // decoration: CustomInputDecoration.loginInputDecoration(
                    //     "Current Password")
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Text("New Password",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .apply(color: HexColor.fromHex(colorBlue))),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    obscureText: _newPasswordObscureText,
                    style: TextStyle(
                        color: HexColor.fromHex(bottomNavigationIdealState)),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("This field can't be empty");
                      } else if (value.length <= 5) {
                        return ("Password can't be less than 6 characters");
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      this.newPassword = value;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Foundation.key,
                            color: HexColor.fromHex(colorBlue)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _newPasswordObscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: HexColor.fromHex(colorBlue),
                          ),
                          onPressed: () {
                            setState(() {
                              _newPasswordObscureText =
                                  !_newPasswordObscureText;
                            });
                          },
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor.fromHex(colorBlue)))),
                    // decoration: CustomInputDecoration.loginInputDecoration(
                    //     "New Password")
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    child: Text("Update"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _updatePasswordBloc.updatePassword(
                            currentPassword, newPassword, newPassword);
                        _progressDialog.show();
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _updatePasswordBloc.dispose();
    super.dispose();
  }
}
