import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mero_school/business_login/blocs/edit_profile_bloc.dart';
import 'package:mero_school/data/models/response/edit_profile_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/utils/app_message_dialog.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../../../business_login/blocs/user_data_bloc.dart';
import '../../../../business_login/user_state_view_model.dart';
import '../../../../webengage/tags.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late UserDataBloc _userDataBloc;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _biography = empty;
  String? _email = empty;
  String? _phoneNumber = empty;
  String? _facebookLink = empty;
  String? _firstName = empty;
  String? _lastName = empty;
  String? _linkedinLink = empty;
  String? _twitterLink = empty;
  late EditProfileBloc _editProfileBloc;
  late AppProgressDialog _progressDialog;
  late AppMessageDialog _appMsgDialog;
  File? _image;
  bool uploadImage = false;
  final picker = ImagePicker();

  bool isShown = false;

  void callback(String id) {
    // print("issue");
    _appMsgDialog.hide();
  }

  @override
  void initState() {
    _userDataBloc = UserDataBloc();

    _editProfileBloc = EditProfileBloc();
    _editProfileBloc.init();
    _progressDialog = new AppProgressDialog(context);
    _appMsgDialog = new AppMessageDialog(context, callback: callback);

    super.initState();
  }

  @override
  void dispose() {
    _userDataBloc.dispose();

    _editProfileBloc.dispose();
    super.dispose();
  }

  Future<SharedPreferences> getPref() async {
    // print("setpRefCalled");
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    // SharedPreferences pref = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: HexColor.fromHex(bottomNavigationEnabledState)),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Image.asset(
            logo_no_text,
            height: 38,
            width: 38,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                String? t = await Preference.getString(token);
                Provider.of<UserStateViewModel>(context, listen: false)
                    .remove();
                _userDataBloc.fetchLogoutSingle(t.toString());
                _userDataBloc.deleteData();
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.delete,
                color: HexColor.fromHex(colorPrimary),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<SharedPreferences>(
                future: getPref(),
                builder: (context, snapshot) {
                  log(snapshot.data.toString());
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Column(
                          children: [
                            Text("Update Display Picture",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor.fromHex(colorPrimary),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        uploadPicture(snapshot.data!),
                        basicInformation(snapshot.data!)
                      ],
                    );
                  } else {
                    return Error(
                      errorMessage: "error loading user data",
                    );
                  }
                }),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
    );
  }

  Widget uploadPicture(SharedPreferences pref) {
    var profileImage = pref.getString(image_profile);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipOval(
            child: _image == null
                ? FadeInImage.assetNetwork(
                    placeholder: ic_account,
                    image: profileImage == null
                        ? user_placeholder
                        : "$profileImage",
                    height: 75,
                    width: 75,
                    fit: BoxFit.contain,
                  )
                : Image.file(_image!,
                    height: 75, width: 75, fit: BoxFit.contain)),
        ElevatedButton.icon(
            onPressed: () {
              _imgFromGallery();
            },
            icon: Icon(Icons.camera_alt),
            label: Text("CHOOSE IMAGE")),
        Visibility(
          visible: uploadImage,
          child: ElevatedButton.icon(
              onPressed: () {
                uploadImageInServer();
              },
              icon: Icon(AntDesign.upload),
              label: Text("UPLOAD IMAGE")),
        ),
      ],
    );
  }

  Widget basicInformation(SharedPreferences pref) {
    // final givenEmail = pref.getString(email);
    // final requiredEmail = givenEmail!.replaceAll(RegExp(r'[^0-9]'), '');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 12,
            ),
            Text("Basic Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex(colorPrimary),
                )),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              initialValue: "${pref.getString(first_name)}",
              maxLines: 1,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("This field can't be empty");
                }
                return null;
              },
              onSaved: (String? value) {
                _firstName = value;
              },
              decoration: CustomInputDecoration.editProfileInputDecoration(
                  "First Name", EvilIcons.user),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              initialValue: "${pref.getString(last_name)}",
              maxLines: 1,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("This field can't be empty");
                }
                return null;
              },
              onSaved: (String? value) {
                _lastName = value;
              },
              decoration: CustomInputDecoration.editProfileInputDecoration(
                  "Last Name", EvilIcons.user),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              initialValue: pref.getString(user_email)!.contains("@mero.school")
                  ? ""
                  : "${pref.getString(user_email)}",
              maxLines: 1,
              enabled:
                  pref.getString(login_via) != "You are logged in via : Google",
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
              onSaved: (String? value) {
                _email = value;
              },
              decoration: CustomInputDecoration.editProfileInputDecoration(
                  "Your Unique Email", MaterialCommunityIcons.email),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              initialValue: "${pref.getString(phone_number)}",
              maxLines: 1,
              enabled: pref.getString(login_via) !=
                  "You are logged in via :  Phone Number",
              validator: (value) {
                bool phoneValid = value!.length > 8;
                if (value.isEmpty) {
                  return ("This field can't be empty");
                } else if (!phoneValid) {
                  return ("Phone is invalid.");
                }
                return null;
              },
              onSaved: (String? value) {
                _phoneNumber = value;
              },
              decoration: (pref.getString(login_via) ==
                      "You are logged in via :  Phone Number")
                  ? CustomInputDecoration.editProfileInputDecoration(
                      pref.getString(phone_number)!,
                      MaterialCommunityIcons.phone)
                  : CustomInputDecoration.editProfileInputDecoration(
                      "Contact Number", MaterialCommunityIcons.phone),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              initialValue: "${pref.getString(biography)}",
              validator: (value) {
                return null;
              },
              onSaved: (String? value) {
                _biography = value;
              },
              decoration: CustomInputDecoration.editProfileInputDecoration(
                  "Biography", MaterialCommunityIcons.circle_edit_outline),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              initialValue: "${pref.getString(twitter)}",
              maxLines: 1,
              validator: (value) {
                return null;
              },
              onSaved: (String? value) {
                _twitterLink = value;
              },
              decoration: CustomInputDecoration.editProfileInputDecoration(
                  "Add your Twitter link", SimpleLineIcons.social_twitter),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              initialValue: "${pref.getString(facebook)}",
              maxLines: 1,
              validator: (value) {
                return null;
              },
              onSaved: (String? value) {
                _facebookLink = value;
              },
              decoration: CustomInputDecoration.editProfileInputDecoration(
                  "Add your Facebook link", SimpleLineIcons.social_facebook),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              initialValue: "${pref.getString(linkedin)}",
              maxLines: 1,
              validator: (value) {
                return null;
              },
              onSaved: (String? value) {
                _linkedinLink = value;
              },
              decoration: CustomInputDecoration.editProfileInputDecoration(
                  "Add your Linkedln link", SimpleLineIcons.social_linkedin),
            ),
            SizedBox(
              height: 12,
            ),
            StreamBuilder<Response<EditProfileResponse>>(
                stream: _editProfileBloc.dataStream,
                builder: (context, response) {
                  if (response.hasData) {
                    // print("reachedUpdateProfiel: * ${response.data.status}");

                    switch (response.data!.status) {
                      case Status.LOADING:
                        _progressDialog.show();
                        return _submitButton();
                        break;
                      case Status.COMPLETED:
                        // _progressDialog.hide();
                        // _appMsgDialog.show(response.data.data.message, "id", "Okey");

                        // print("debugwith keshav");
                        // Future.delayed(Duration.zero, () {
                        //
                        _progressDialog
                            .hide()
                            .onError((dynamic error, stackTrace) {
                          // ToastHelper.showLong(response.data!.data!.message!);
                          if (_progressDialog.isShowing()) {
                            _progressDialog.hide();
                          }
                          return true;
                        }).then((value) {
                          if (response.data?.data?.data?.isProfileCompleted ==
                              false) {
                            WebEngagePlugin.trackEvent(TAG_PROFILE_COMPLETED, {
                              'name': "$_firstName" + " " + "$_lastName",
                              'email': _email,
                              'phone': _phoneNumber,
                            });
                            // WebEngagePlugin.trackEvent(TAG_PROFILE_COMPLETED, {
                            //   'name':
                            //       "${response.data?.data?.data?.firstName} ${response.data?.data?.data?.lastName}",
                            //   'email': "${response.data?.data?.data?.email}",
                            //   'phone':
                            //       "${response.data?.data?.data?.phoneNumber}",
                            // });
                          }
                        });
                        // });

                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        //   _progressDialog.hide().onError((error, stackTrace) =>
                        //
                        //     ToastHelper.showLong(response.data.data.message)
                        //
                        //   ).then((value) {
                        //     print('hello show');
                        //     _appMsgDialog.show(response.data.data.message, "id", "Okey");
                        //
                        //   }
                        //
                        //
                        //   );
                        // });

                        // _splashBloc.saveData(snapshot.data.data,context);
                        // debugPrint("Status.COMPLETED progress bar");
                        // callDashboard();
                        // ToastHelper.showLong(response.data.data.message);

                        return _submitButton();

                      // return mainView(displayJoke: snapshot.data.data);
                      // break;
                      case Status.ERROR:
                        // debugPrint("Status.ERROR");
                        // WidgetsBinding.instance!.addPostFrameCallback((_) {
                        //   _progressDialog.hide();
                        // });

                        if (!isShown) {
                          isShown = true;
                          Fluttertoast.showToast(msg: response.data!.message!);
                        }

                        // if (!isShown) {
                        //   while (isShown = true) {
                        //     ToastHelper.showErrorLong(response.data!.message!)
                        //         .then(() {
                        //       isShown = false;
                        //     });
                        //   }

                        //   return _submitButton();
                        // }
                        return _submitButton();

                      // return Error(
                      //   errorMessage: snapshot.data.message,
                      //   onRetryPressed: () => _splashBloc.fetchSystemSettings(),
                      // );
                      // break;

                      default:
                        return _submitButton();
                    }
                  } else {
                    return _submitButton();
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    Future<void> postData() async {
      var x = await Preference.getString(token);

      await _editProfileBloc.updateProfile(_biography, _email, _facebookLink,
          _firstName, _lastName, _linkedinLink, _twitterLink, _phoneNumber);

      final request = await http
          .post(Uri.parse('https://mero.school/Api/update_userdata'), body: {
        "auth_token": x,
        "biography": _biography,
        "email": _email,
        "phone_number": _phoneNumber,
        "gender": "",
        "facebook_link": _facebookLink,
        "first_name": _firstName,
        "last_name": _lastName,
        "linkedin_link": _linkedinLink,
        "twitter_link": _twitterLink
      });

      print(request.body);
    }

    return ElevatedButton(
        onPressed: () {
          _formKey.currentState!.validate();

          // FocusScope.of(context).unfocus();
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            Fluttertoast.cancel();
            _formKey.currentState!.save();
            postData();
            postData();
            isShown = false;
          }
        },
        child: Text("SUBMIT"));
  }

  _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    // File image = await _imageFile.(
    //     source: ImageSource.gallery, imageQuality: 50);
    //
    setState(() {
      _image = File(pickedFile!.path);
      if (_image!.isAbsolute) uploadImage = true;
    });
  }

  void uploadImageInServer() {
    _progressDialog.show();
    _editProfileBloc.uploadImage(_image!).then((value) {
      _progressDialog.hide();
      ToastHelper.showShort(value.message!);
    });
  }
}
