import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mero_school/business_login/blocs/entrance_web_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:mero_school/data/models/response/entrance_config.dart';
import 'package:mero_school/networking/Response.dart';

import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/pages/account/account_page.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class WebPageEntrance extends StatefulWidget {
  @override
  _WebPageEntranceState createState() => _WebPageEntranceState();
}

class _WebPageEntranceState extends State<WebPageEntrance> {
  bool isLoading = true;
  final _key = UniqueKey();
  // Map? _arguments;
  late EntranceWebBloc _courseBloc;

  @override
  void initState() {
    _courseBloc = EntranceWebBloc();

    super.initState();
  }

  @override
  void dispose() {
    _courseBloc.dispose();
    super.dispose();
  }

  void goBackOrOpenHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  bool isLogged = false;

  @override
  Widget build(BuildContext context) {
    var home = Consumer<UserStateViewModel>(
      builder: (_, auth, __) {
        if (auth.loginToken == null) {
          return Container();
        }

        if (auth.loginToken!.isNotEmpty) {
          print("mainView() ${auth.loginToken}");

          _courseBloc.fetchEntranceData(token: auth.loginToken);

          return mainView();
        } else {
          //post delay

          Future.delayed(Duration.zero, () {
            Navigator.of(context).pushNamed(login_page);
          });

          print("AccountPage()");
          return AccountPage();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: HexColor.fromHex(bottomNavigationEnabledState)),
          onPressed: () {
            goBackOrOpenHome();
          },
        ),
        title: Image.asset(
          logo_no_text,
          height: 38,
          width: 38,
        ),
      ),
      body: home,
    );
  }

  Widget mainView() {
    return Stack(
      children: [
        StreamBuilder<Response<Entrance_config>>(
          stream: _courseBloc.dataEntranceConfigStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.status == Status.COMPLETED) {
                print("fetchingUrl: ${snapshot.data!.data!.data!.url}");

                if (!isLogged) {
                  isLogged = true;
                  var url = "${snapshot.data?.data?.data?.url}";

                  var uri = Uri.dataFromString(url); //converts string to a uri
                  var maps = uri.queryParameters;

                  WebEngagePlugin.trackEvent(TAG_ENTRANCE_WEB_STRTED, {
                    'Title': '${snapshot.data?.data?.data?.title}',
                    'SubTitle': '${snapshot.data?.data?.data?.subtitle}',
                    'Phone': '${maps['Mobile']}',
                    'Email': '${maps['Email']}',
                    'LevelId': '${maps['LevelId']}',
                    'CourseId': '${maps['CourseId']}',
                    'Tag': '${maps['Tag']}'
                  });
                }

                return InAppWebView(
                    key: _key,
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(snapshot.data!.data!.data!.url!)),
                    onLoadStop: (controller, uri) {
                      var url = uri.toString();
                      debugPrint("My Url $url");
                      if (isLoading) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    });
              } else {
                return new Container();
              }
            } else {
              return new Container();
            }
          },
        ),
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(),
      ],
    );
  }
}
