import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:mero_school/business_login/blocs/splash_bloc.dart';
import 'package:mero_school/data/models/response/system_settings_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';

class PaymentMethod extends StatefulWidget {
  Function(String)? callback;
  SystemSettingsResponse? systemSettingsResponse;

  PaymentMethod({Key? key, this.callback, this.systemSettingsResponse})
      : super(key: key);

  @override
  _PaymentMethodState createState() {
    return _PaymentMethodState();
  }
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  void initState() {
    _splashBloc = SplashBloc();
    _splashBloc.systemSettingsBloc();

    if (widget.systemSettingsResponse == null) {
      _splashBloc.fetchSystemSettings();
    } else {
      _splashBloc.updateSystemSetting(widget.systemSettingsResponse);
    }

    super.initState();
  }

  late SplashBloc _splashBloc;

  @override
  void dispose() {
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<Response<SystemSettingsResponse>>(
            stream: _splashBloc.settingDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return loadImage();
                    break;
                  case Status.COMPLETED:
                    _splashBloc.saveData(snapshot.data!.data!).then((value) {
                      print('Update checkout');
                      print(snapshot.data!.message);
                    });

                    return mainVeiw(context, snapshot.data!.data);

                    break;
                  case Status.ERROR:
                    var showLong =
                        ToastHelper.showLong(snapshot.data!.message!);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "No Any Payment Method Currently Active. Please Try Again Later.",
                          textAlign: TextAlign.center),
                    );

                    // return  mainVeiw(context,null);

                    break;
                }
              }
              return loadImage();
            }));
  }

  Widget loadImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: Lottie.asset('assets/progress_two.json'),
          ),
          Text("fetching active payment methods..."),
        ],
      ),
    );
  }

  Widget mainVeiw(BuildContext context, SystemSettingsResponse? data) {
    var platformIos = Platform.isIOS;

    var displaySG = false;
    var displayBank = false;
    var displayNcell = false;
    var displayApplePay = false;
    var displayHelper = false;
    var displayGooglePay = true;

    //ios
    if (platformIos) {
      displaySG = data!.data!.hideSmartGatewayIos == "true" ? false : true;

      //hard code sg display

      displayBank = (data.data!.hideBankPaymentIos == "true") ? false : true;
      displayNcell = (data.data!.hideNcellPaymentIos == "true") ? false : true;
      displayApplePay = (data.data!.iosPay == "true") ? false : true;
      displayHelper =
          (data.data!.hidePayText == "true" && data.data!.youtube == "true")
              ? false
              : true;
    } else {
      displaySG =
          (data!.data!.hideSmartGatewayAndriod == "true") ? false : true;
      displayBank =
          (data.data!.hideBankDepositPaymentAndroid == "true") ? false : true;
      displayNcell =
          (data.data!.hideNcellPaymentAndroid == "true") ? false : true;
      displayHelper =
          (data.data!.hidePayText == "true" && data.data!.youtube == "true")
              ? false
              : true;
    }

    Widget sgItem;
    Widget bankItem;
    Widget ncellItem;
    Widget applePay;
    Widget helperItem;
    Widget googlePay;

    // if(root_url.contains("demo")){
    //   displaySG = true;
    // }
    //

    print("displayNcell: $displayNcell");
    print("displayBank: $displayBank");
    print("displaySg: $displaySG");
    print("displayHelper: $displayHelper");
    print("displayGoogle: $displayGooglePay");

    if (displayHelper) {
      helperItem = OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: HexColor.fromHex(colorPrimary),
        ),
        onPressed: () {
          ChromeSafariBrowser().open(
            url: Uri.parse(data.data!.youtube!),
            // url: Uri.parse(youtubeLink),
          );
        },
        child: Text(
          data.data!.hidePayText!
          // 'Watch instructions for payment process.'
          ,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else {
      helperItem = Container();
    }

    if (displayGooglePay) {
      googlePay = Column(
        children: [
          Card(
            child: ListTile(
              leading: new Container(
                width: 90,
                child: new Image.asset(ic_google_pay),
              ),
              title: new Text(
                'Google In-App Purchase',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                // final x = await _splashBloc.fetchSystemSettings();
                // log("RESPONSEEEEEEE: " + data.toJson().toString());
                widget.callback!("google-pay");
              },
            ),
          ),
        ],
      );
    } else {
      googlePay = Container();
    }

    if (displaySG) {
      sgItem = Column(
        children: [
          Card(
            child: ListTile(
              leading: new Container(
                width: 90,
                child: new Image.asset(ic_sg),
              ),
              title: new Text(
                'Online Payment',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                print(123123);
                widget.callback!("smart-gateway");
              },
            ),
          ),
        ],
      );
    } else {
      sgItem = Container();
    }

    if (displayBank) {
      bankItem = Card(
        child: ListTile(
          leading: new Container(
            width: 90,
            child: new Image.asset(
              ic_deposit,
              width: 32,
              height: 32,
            ),
          ),
          title: new Text('Bank Payment',
              style: TextStyle(fontWeight: FontWeight.w500)),
          onTap: () {
            widget.callback!("bank-payment");
          },
        ),
      );
    } else {
      bankItem = Container();
    }

    if (displayNcell) {
      ncellItem = Card(
        child: ListTile(
          leading: new Container(
            width: 90,
            child: new Image.asset(ic_ncell),
          ),
          title: new Text('Ncell Payment',
              style: TextStyle(fontWeight: FontWeight.w500)),
          onTap: () {
            widget.callback!("ncell-payment");
          },
        ),
      );
    } else {
      ncellItem = Container();
    }

    print("");

    //hardcode:
    // displayApplePay = true;

    if (displayApplePay) {
      applePay = Card(
        child: ListTile(
          leading: new Container(
            width: 90,
            child: Padding(
                padding: EdgeInsets.all(8.0), child: new Image.asset(ic_apple)),
          ),
          title: new Text('In-App Purchase',
              style: TextStyle(fontWeight: FontWeight.w500)),
          onTap: () {
            widget.callback!("apple-pay");
          },
        ),
      );
    } else {
      applePay = Container();
    }

    Widget emtpy = Container();

    if (!displaySG &&
        !displayBank &&
        !displayNcell &&
        !displayApplePay &&
        !displayGooglePay) {
      emtpy = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            "No Any Payment Method Currently Active. Please Try Again Later.",
            textAlign: TextAlign.center),
      );
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 4),
                child: Text(
                  "Pay With",
                  style: TextStyle(color: HexColor.fromHex(colorDarkRed)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 10, 4),
                  child: helperItem),
            ],
          ),
          sgItem,
          bankItem,
          ncellItem,
          applePay,
          googlePay,
          emtpy
        ],
      ),
    );
  }
}
