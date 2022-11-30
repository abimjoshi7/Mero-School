import 'package:flutter/material.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:webview_flutter/webview_flutter.dart' as web;

import '../../../../utils/extension_utils.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../constants/strings.dart';

class EarningReport extends StatelessWidget {
  Future<String?> getId() {
    return Preference.getString(user_id);
  }

  EarningReport({Key? key}) : super(key: key);

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
            return web.WebView(
                initialUrl: "https://demo.mero.school/earning-report-api/$id");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(children: [
      //     SizedBox(
      //       height: 10,
      //     ),
      //     Container(
      //       alignment: Alignment.center,
      //       child: Text(
      //         "Assigned Coupon Codes",
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
      //               'Coupon\nCode',
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
      //               'Created\nDate',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Total',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Paid',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Unpaid',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Used\nCoupon',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Status',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Action',
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
      //             '2022-05-24',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '2022-04-25 14:29:00',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '3905',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '3905',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '0',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             '6',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             'Paid',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             'Icon',
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
