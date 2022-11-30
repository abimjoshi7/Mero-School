import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mero_school/business_login/blocs/splash_bloc.dart';
import 'package:mero_school/data/models/response/system_settings_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUSPageState createState() => _AboutUSPageState();
}

class _AboutUSPageState extends State<AboutUsPage> {
  var appVersion = "";

  Future<String> getPref() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  late SplashBloc _splashBloc;

  @override
  void initState() {
    _splashBloc = SplashBloc();
    _splashBloc.systemSettingsBloc();
    _splashBloc.fetchSystemSettingsWithSplash();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WebEngagePlugin.trackScreen(TAG_PAGE_ABOUT);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: HexColor.fromHex(bottomNavigationEnabledState)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, est);
            },
            child: Image.asset(
              logo_no_text,
              height: 38,
              width: 38,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<Response<SystemSettingsResponse>>(
              stream: _splashBloc.settingDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data?.data?.data;

                  switch (snapshot.data?.status) {
                    case Status.LOADING:
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60.0,
                            height: 60.0,
                            child: Lottie.asset('assets/progress_two.json'),
                          ),
                        ],
                      );
                      break;
                    case Status.COMPLETED:
                      var phone = "";

                      if (data?.phone != null &&
                          data?.phone?.isNotEmpty == true) {
                        phone = "${data?.phone}";
                      }

                      if (data?.alternatePhone != null &&
                          data?.alternatePhone?.isNotEmpty == true) {
                        phone = "$phone / ${data?.alternatePhone}";
                      }

                      return Column(children: [
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${(null != data?.slogan) ? data?.slogan : ""}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .apply(
                                            color: HexColor.fromHex(
                                                bottomNavigationEnabledState)),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "${(null != data?.websiteDescription) ? data?.websiteDescription : ""}",
                                    style: TextStyle(
                                        color: HexColor.fromHex(
                                            bottomNavigationEnabledState)),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      shareDynamicLink(data?.websiteDescription,
                                          data?.og_url);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          AntDesign.sharealt,
                                          color: HexColor.fromHex(
                                              bottomNavigationEnabledState),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Share Mero School",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .apply(
                                                  color: HexColor.fromHex(
                                                      bottomNavigationEnabledState)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    "Contact us",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .apply(
                                            color: HexColor.fromHex(
                                                bottomNavigationEnabledState)),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // _launchCaller();

                                      var d = data?.address;

                                      MapsLauncher.launchQuery(d.toString());
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_sharp,
                                          color: HexColor.fromHex(
                                              bottomNavigationEnabledState),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${data?.address}",
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    bottomNavigationEnabledState)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _launchCaller();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.phone_in_talk_rounded,
                                          color: HexColor.fromHex(
                                              bottomNavigationEnabledState),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "$phone",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    bottomNavigationEnabledState)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _emailLaunchUri();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(AntDesign.mail,
                                            color: HexColor.fromHex(
                                                bottomNavigationEnabledState)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${data?.systemEmail}",
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  bottomNavigationEnabledState)),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    "App Info",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .apply(
                                            color: HexColor.fromHex(
                                                bottomNavigationEnabledState)),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  FutureBuilder(
                                      future: getPref(),
                                      builder: (context, snapshot) {
                                        appVersion = snapshot.data.toString();

                                        return Text(
                                          "Version $appVersion",
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  bottomNavigationEnabledState)),
                                        );
                                      })
                                ])),
                      ]);
                      break;
                    case Status.ERROR:
                      break;
                    case Status.SUCCESS:
                      break;
                    case Status.LOGOUT:
                      break;
                    case Status.COMPLETE_MESSAGE:
                      break;
                  }
                }
                return SizedBox();
              }),
        ));
  }

  Future<void> _launchCaller() async {
    var number = await Preference.getString(phone);
    var alternetNumber = await Preference.getString(phone_alternate);

    print("Phone: $number Alternet number: $alternetNumber");

    var url = 'tel:$number';

    List<String> list = [];

    if (number != null && number.isNotEmpty) {
      var alts = number.trim().split("/");
      alts.forEach((element) {
        if (element.isNotEmpty) {
          list.add(element);
        }
      });
    }

    if (alternetNumber != null) {
      var alts = alternetNumber.trim().split("/");

      alts.forEach((element) {
        if (element.isNotEmpty) {
          list.add(element);
        }
      });
    }

    print("numbers: $list");

    if (list.length > 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Contact us'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: list.map((e) {
                    return ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        url = 'tel:$e';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      title: Text(e),
                    );
                  }).toList(),
                ));
          });
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    // var url  = 'tel://+977 1-5320071';
  }

  Future<void> _emailLaunchUri() async {
    //Preference.prefs.getString(systemEmail)

    var s = await Preference.getString(systemEmail);
    final Uri _emailUri = Uri(
      scheme: 'mailto',
      path: s,
    );
    launch(_emailUri.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _splashBloc.close();
  }

  void shareDynamicLink(String? desc, String? thumb) async {
    WebEngagePlugin.trackEvent(TAG_APP_LINK_SHARE, {});

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      androidParameters: AndroidParameters(packageName: 'school.mero.lms'),
      iosParameters: IOSParameters(bundleId: 'school.mero.lms'),
      uriPrefix: 'https://share.mero.school',
      link: Uri.parse('https://mero.school'),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Mero School',
          description: desc,
          imageUrl: Uri.parse((null != thumb)
              ? thumb
              : 'https://blog.mero.school/wp-content/uploads/2021/11/meroschoolpic.jpg')),
      // socialMetaTagParameters:
    );
    // final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri shortUrl = shortDynamicLink.shortUrl;
    await Share.share(shortUrl.toString());
  }
}
