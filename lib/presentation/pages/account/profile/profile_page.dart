import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/business_login/blocs/user_data_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:mero_school/data/models/response/user_data_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/logout_alert_dialog.dart';
import 'package:mero_school/utils/app_menu.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/image_error.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../account_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserDataBloc _userDataBloc;
  late AppProgressDialog _progressDialog;

  @override
  void initState() {
    _userDataBloc = UserDataBloc();
    _progressDialog = new AppProgressDialog(context);

    // _userDataBloc.initBloc();
    super.initState();

    // Provider.of<UserStateViewModel>(context, listen: true);
  }

  Future<void> continueCallBack() async {
    // Provider.of<UserStateViewModel>(context, listen: false).deleteCurrentLoginStatus();

    //
    // _progressDialog = new AppProgressDialog(context);
    // _progressDialog.show();

    String? t = await Preference.getString(token);

    Provider.of<UserStateViewModel>(context, listen: false).remove();

    _userDataBloc.fetchLogoutSingle(t.toString());

    _userDataBloc.deleteData();

    // await locator<AppDatabase>().deleteCartData(model);
  }

  //obtain token
  @override
  Widget build(BuildContext context) {
    var home = Consumer<UserStateViewModel>(
      builder: (_, auth, __) {
        if (auth.loginToken == null) {
          return Container();
        }

        if (auth.loginToken!.isNotEmpty) {
          // print("token: " + auth.loginToken!);
          _userDataBloc.initBloc();
          return mainView();
        } else {
          return AccountPage();
        }
      },
    );

    return home;
  }

  Widget _profilePage(String? url, String name,
      {bool? displayPassword = false, String? provider}) {
    // print("provided: $provider");

    return Container(
      margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
      child: Column(
        children: [
          Column(
            children: [
              ClipOval(
                  child: FadeInImage.assetNetwork(
                placeholder: ic_account,
                image: url == empty
                    ? "https://mero.school/uploads/user_image/placeholder.png"
                    : url!,
                height: 75,
                width: 75,
                imageErrorBuilder: (_, __, ___) {
                  return ImageError(
                    size: 75,
                  );
                },
                fit: BoxFit.cover,
              )),
              SizedBox(
                height: 10,
              ),
              Text(name),
              SizedBox(
                height: 10,
              ),
              Text((provider == null) ? "" : "$provider"),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text("Account Page",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .apply(color: HexColor.fromHex(colorDarkRed))),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      MoreMenu(
                          title: "Edit Profile",
                          icon: Icons.person,
                          callback: () {
                            callEditProfile();
                          }),
                      displayPassword == true
                          ? MoreMenu(
                              title: "Change password",
                              icon: Icons.vpn_key_rounded,
                              callback: () {
                                Navigator.of(context)
                                    .pushNamed(profile_change_password);
                              })
                          : SizedBox(),
                      MoreMenu(
                          title: "Wishlist",
                          icon: MaterialCommunityIcons.heart,
                          callback: () {
                            Navigator.pushNamed(context, route_wish_list);
                          }),
                      MoreMenu(
                          title: "All Transactions",
                          icon: MaterialCommunityIcons.finance,
                          callback: () {
                            Navigator.pushNamed(
                                context, my_transaction_history);
                          }),
                      MoreMenu(
                        title: "Log Out",
                        icon: Icons.logout,
                        callback: () {
                          var dialog = LogOutAlertDialog("Mero School",
                              "Are you sure logout ?", continueCallBack);

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return dialog;
                            },
                          );
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editProfile() {
    return InkWell(
      onTap: () {
        callEditProfile();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: HexColor.fromHex(colorBlue),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Edit Profile",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .apply(color: Colors.black87),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: HexColor.fromHex(bottomNavigationIdealState),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userDataBloc.dispose();
    super.dispose();
  }

  Widget mainView() {
    return SingleChildScrollView(
      child: StreamBuilder<Response<UserDataResponse>>(
          stream: _userDataBloc.dataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print("reachedUpdateProfiel: ${snapshot.data!.status}");

              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return _profilePage(empty, empty);
                case Status.COMPLETED:
                  var model = snapshot.data!.data!.data!;
                  _userDataBloc.saveData(snapshot.data!.data!);

                  var displayChangePasword =
                      snapshot.data?.data?.data?.provider.toString();

                  var display = true;

                  if (displayChangePasword != null &&
                      displayChangePasword.isNotEmpty == true) {
                    display = false;
                  }

                  return _profilePage(
                      model.image, "${model.firstName} ${model.lastName}",
                      displayPassword: display, provider: model.loginVia);
                case Status.ERROR:
                  _progressDialog.hide();

                  return _profilePage(empty, empty);

                case Status.LOGOUT:
                  print("<<<<<<<<<<<<<removed token");
                  Provider.of<UserStateViewModel>(context, listen: false)
                      .remove();

                  WidgetsBinding.instance.addPostFrameCallback((_) => {
                        _progressDialog
                            .hide()
                            .then((value) => {callLoginPage()})
                      });

                  return AccountPage();

                default:
                  return _profilePage(empty, empty);
              }
            } else {
              return _profilePage(empty, empty);
            }
          }),
    );
  }

  callLoginPage() async {
    print("save== callLoginPage remove everythings");
    _userDataBloc.deleteData();

    // Navigator.of(context).pushNamed(login_page);
  }

  Future<SharedPreferences> getPref() async {
    print("setpRefCalled");
    return await SharedPreferences.getInstance();
  }

  void callEditProfile() async {
    var sharePref = await getPref();

    Navigator.of(context)
        .pushNamed(edit_profile, arguments: sharePref)
        .then((value) {
      // print("value: $value");

      if (value as bool) {
        _userDataBloc.fetchData();
      }
    });
    // if (result) {
    //   _userDataBloc.fetchData();
    // }
  }
}
