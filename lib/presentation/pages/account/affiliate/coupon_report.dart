import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/extension_utils.dart';
import '../../../../utils/preference.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../constants/strings.dart';

class CouponReport extends StatelessWidget {
  Future<String?> getId() {
    return Preference.getString(user_id);
  }

  const CouponReport({Key? key}) : super(key: key);

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
        title: Row(
          children: [
            Image.asset(
              logo_no_text,
              height: 38,
              width: 38,
            ),
          ],
        ),
      ),
      body: FutureBuilder<String?>(
        future: getId(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            String? id = snapshot.data;
            return WebView(
                initialUrl: " https://demo.mero.school/coupon-report-api/$id");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(children: [
      //     SizedBox(
      //       height: 10,
      //     ),
      //     Container(
      //       alignment: Alignment.center,
      //       child: Text(
      //         "Coupon Report",
      //         style: TextStyle(
      //           fontSize: 22,
      //           fontWeight: FontWeight.bold,
      //           color: HexColor.fromHex(darkNavyBlue),
      //         ),
      //       ),
      //     ),
      //     SizedBox(
      //       height: 10,
      //     ),
      //     Divider(thickness: 0.5, color: Colors.black),
      //     Table(
      //       // defaultColumnWidth: FlexColumnWidth(3),
      //       children: [
      //         TableRow(
      //           children: [
      //             Text(
      //               'S.N',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Coupon\nName',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Start\nDate',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'End\nDate',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Commission\nRate (%)',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'User\nApply\nCoupon',
      //               textAlign: TextAlign.center,
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //     Divider(thickness: 0.5, color: Colors.black),
      //     Table(
      //       children: List.generate(
      //         3,
      //         (index) => TableRow(children: [
      //           Text(
      //             '1',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '1MMINLHX',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             "2022-04-25",
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '2023-08-09',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '20',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '6 ',
      //             textAlign: TextAlign.center,
      //           ),
      //         ]),
      //       ),
      //     ),
      //   ]),
      // ),
    );
  }
}
