import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/pages/splash_page.dart';
import 'package:url_launcher/url_launcher.dart';

var url = "";

class WebPage extends StatefulWidget {
  void launchURL() async {
    if (await canLaunchUrl(Uri.parse(url)))
      await launchUrl(Uri.parse(url));
    else
      throw "Could not launch $url";
  }

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> with WidgetsBindingObserver {
  late AppLifecycleState _appLifecycleState;
  bool isLoading = true;
  final _key = UniqueKey();
  Map? _arguments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      return widget.launchURL();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("the state is: " + state.name);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('Hi');
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _launchURL();
  }

  void goBackOrOpenHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  var _webViewController;
  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    if (_arguments?.containsKey("paymentUrl") == true) {
      url = _arguments!["paymentUrl"];
    } else if (_arguments?.containsKey("course_id") == true) {
      url = _arguments!["course_id"];
    } else {
      print("DISTURBING URL:" + url);
    }

    print("url $url --> final");

    return Scaffold(
      body: SplashPage(),
    );
    //   body: Web.WebView(
    //       initialUrl: url,
    //       javascriptMode: Web.JavascriptMode.unrestricted,
    //       allowsInlineMediaPlayback: true,
    //       gestureNavigationEnabled: true),
    // appBar: AppBar(
    //   backgroundColor: Colors.white,
    //   leading: IconButton(
    //     icon: Icon(Icons.arrow_back_ios,
    //         color: HexColor.fromHex(bottomNavigationEnabledState)),
    //     onPressed: goBackOrOpenHome,
    //   ),
    //   title: Image.asset(
    //     logo_no_text,
    //     height: 38,
    //     width: 38,
    //   ),
    // ),
    // body: Stack(
    //   children: [
    //     InAppWebView(
    //         key: _key,
    //         initialOptions: InAppWebViewGroupOptions(
    //             android:
    //                 AndroidInAppWebViewOptions(useHybridComposition: true)),
    //
    //         // initialUrlRequest: ,
    //         initialUrlRequest: URLRequest(url: Uri.parse(url)),
    //         // initialUrlRequest: URLRequest(url: Uri.parse("https://demo.mero.school/home/transaction_failed_mobile_respond/FAILED/c00923e3625e")),
    //         onWebViewCreated: (controller) {
    //           _webViewController = controller;
    //           //SmartFunction.withAgent('KHALTI')
    //           // _webViewController.addJavaScriptHandler(handlerName: "withAgent", callback: (args){
    //           //     print("args: $args");
    //           //
    //           //     List<String> stringList = (args as List<dynamic>).cast<String>();
    //           //
    //           //     status = stringList[0];
    //           //     txnId = stringList[1];
    //           //     agent = stringList[2];
    //           //
    //           //     print("args: $status, $txnId, $agent");
    //           //
    //           //
    //           //
    //           //
    //           //   // return args.reduce((curr, next) => curr + next);
    //           // });
    //
    //           // _webViewController.addJavaScriptHandler(handlerName: "onBack", callback: (args){
    //           //     Navigator.of(context).pop(status);
    //           //   // return args.reduce((curr, next) => curr + next);
    //           // });
    //         },
    //         onLoadStop: (controller, uri) {
    //           var url = uri.toString();
    //
    //           debugPrint("My Url $url");
    //           if (isLoading) {
    //             setState(() {
    //               isLoading = false;
    //             });
    //           }
    //
    //           // if (url.contains("mobile_respond")) {
    //           //   if (url.contains("mobile_respond/Success")) {
    //           //     deleteAllCartData();
    //           //     // Navigator.pushNamed(context, my_transaction_history);
    //           //   }
    //           // }
    //         }),
    //     isLoading
    //         ? Center(
    //             child: CircularProgressIndicator(),
    //           )
    //         : Stack(),
    //   ],
    // ),
    // );
  }
}
