import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/extension_utils.dart';
import '../../../../utils/preference.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../constants/strings.dart';

class PaymentHistory extends StatelessWidget {
  Future<String?> getId() {
    return Preference.getString(user_id);
  }

  const PaymentHistory({Key? key}) : super(key: key);

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
                initialUrl: "https://demo.mero.school/payment-history-api/$id");
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
      //               'Payment\nDate',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Payment\nMethod',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Paid\nAmount',
      //               textAlign: TextAlign.center,
      //             ),
      //             Text(
      //               'Reference\nNumber',
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
      //             '2022-05-24 13:08:43',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             'NIC ASIA',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             'Rs 120 ',
      //             textAlign: TextAlign.center,
      //           ),
      //           Text(
      //             'dfsdfdsf12310',
      //             textAlign: TextAlign.center,
      //           ),
      //         ]),
      //       ),
      //     ),
      //   ]),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var response = await http.get(Uri.parse(
      //         'https://demo.mero.school/user-apply-coupon-code/1106'));
      //     print(response.body);
      //   },
      // ),
    );
  }
}
