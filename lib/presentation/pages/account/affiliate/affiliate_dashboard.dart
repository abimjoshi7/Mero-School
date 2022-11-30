import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/extension_utils.dart';
import '../../../../utils/preference.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../constants/route.dart';
import '../../../constants/strings.dart';
import '../../../widgets/loading/loading.dart';

class AffiliateDashboard extends StatefulWidget {
  AffiliateDashboard({Key? key}) : super(key: key);

  @override
  State<AffiliateDashboard> createState() => _AffiliateDashboardState();
}

class _AffiliateDashboardState extends State<AffiliateDashboard> {
  bool isCouponAssign = false;
  final baseUrl = "https://demo.mero.school/Apiv2/dashboard?auth_token=";
  String? t;

  Future<String?> getId() async {
    return await Preference.getString(token);
  }

  Future<Map<String, dynamic>> getData() async {
    t = await Preference.getString(token);
    final response = await http.get(
      Uri.parse(baseUrl + t!),
    );
    print(response.body);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

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
      body: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (_, snapshot) {
          if (snapshot.hasData &&
              snapshot.data!["status"].toString() == "true") {
            if (snapshot.data!["data"]["is_coupon_assign"].toString() == "true")
              isCouponAssign = true;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text("No Internet Connection"),
                );
              case ConnectionState.waiting:
                return Center(
                  child: Loading(),
                );
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: snapshot.data!["is_show_table"] == false
                      ? Center(
                          child: Text(
                          snapshot.data!["message"].toString(),
                          textAlign: TextAlign.center,
                        ))
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                affiliate_dashboard_form,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor.fromHex(darkNavyBlue),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Divider(thickness: 0.5, color: Colors.black),
                            Table(
                              // defaultColumnWidth: FlexColumnWidth(3),
                              children: [
                                TableRow(
                                  children: [
                                    Text(
                                      'Unpaid\nEarning',
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Paid\nEarning',
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Total\nEarning',
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Assigned\nCoupon',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(thickness: 0.5, color: Colors.black),
                            Table(
                              children: List.generate(
                                1,
                                (index) => TableRow(children: [
                                  Text(
                                    "Rs.${snapshot.data!["data"]["unpaid"].toString()} ",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Rs.${snapshot.data!["data"]["paid"].toString()} ",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Rs.${snapshot.data!["data"]["total_commission"].toString()} ",
                                    textAlign: TextAlign.center,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // print(snapshot
                                      //     .data!["is_total_commission"]);
                                      Navigator.pushNamed(
                                          context, assigned_coupons);
                                    },
                                    child: Text(
                                      "${snapshot.data!["data"]["coupon_assign"].toString()}",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                );

              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          } else {
            return Center(
              child: Loading(),
            );
          }
        },
      ),

      // FutureBuilder<String?>(
      //   future: getId(),
      //   builder: (_, snapshot) {
      //     if (snapshot.hasData) {
      //       String? id = snapshot.data;
      //       return WebView(initialUrl: baseUrl + id!);
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      floatingActionButton: floatingAction(context),
      // isCouponAssign == true ? floatingAction(context) : SizedBox(),
    );
  }

  Widget floatingAction(BuildContext context) {
    String? description;
    return FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: ((_) => Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            coupon_request_form,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: HexColor.fromHex(darkNavyBlue),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            description = value;
                          },
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: "Description for coupon code",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor.fromHex(colorPrimary)),
                              onPressed: () async {
                                String? t = await Preference.getString(token);
                                await http.post(
                                    Uri.parse(
                                      "https://demo.mero.school/Apiv2/couponRequest",
                                    ),
                                    body: {
                                      "description": description,
                                      "auth_token": t
                                    }).then((value) => print(value.body));
                                Navigator.pop(context);
                              },
                              child: Text('Send'),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor.fromHex(colorPrimary)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          );
        },
        label: Text('Coupon Request'));
  }
}
