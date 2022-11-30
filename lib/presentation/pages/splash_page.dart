import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/preference.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _splashTime = 5;
  // SplashBloc? _splashBloc;
  @override
  void initState() {
    // _splashBloc = SplashBloc();
    // _splashBloc?.systemSettingsBloc();
    // _splashBloc?.fetchSystemSettingSilent();
    super.initState();
    // WebPage();
    // WebPage().launchURL();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    dashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: loadImage(),
      // child: StreamBuilder<Response<SystemSettingsResponse>>(
      //   stream: _splashBloc.settingDataStream,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       switch (snapshot.data.status) {
      //         case Status.LOADING:
      //           return loadImage();
      //           break;
      //         case Status.COMPLETED:
      //           _splashBloc.saveData(snapshot.data.data, context).then((value){
      //             dashboard();
      //           });
      //
      //           return loadImage();
      //
      //           break;
      //         case Status.ERROR:
      //           ToastHelper.showLong(snapshot.data.message);
      //
      //           dashboard();
      //
      //           return loadImage();
      //
      //           break;
      //
      //       }
      //     }
      //     return loadImage();
      //   },
      // ),
    );
  }

  void dashboard() async {
    var t = await Preference.getString(token);

    if (t == null) {
      Navigator.pushNamedAndRemoveUntil(context, login_page, (route) => false,
          arguments: <String, String>{'root': 'splash'});
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  @override
  void dispose() {
    // _splashBloc.dispose();
    super.dispose();
    // WebPage();
  }

  Widget loadImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(logo, height: 140),
      ],
    );
  }
}
