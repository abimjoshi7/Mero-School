import 'package:flutter/material.dart';

import '../../utils/extension_utils.dart';
import '../constants/colors.dart';
import '../constants/route.dart';

class AffiliateOptions extends StatelessWidget {
  var snapshot;

  AffiliateOptions({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: ExpansionTile(
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.black12,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, affiliate_dashboard);
                    },
                    child: Text('Affiliate Dashboard'),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.6,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, assigned_coupons);
                    },
                    child: Text('Assigned Coupons'),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.6,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, coupon_report);
                    },
                    child: Text('Coupon Report'),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.6,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, coupon_used_report);
                    },
                    child: Text('Coupon Used Report'),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.6,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, payment_history);
                    },
                    child: Text('Payment History'),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.6,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, earning_report);
                    },
                    child: Text('Earning Report'),
                  ),
                ),
              ],
            ),
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.handshake,
              color: HexColor.fromHex(colorBlue),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text("Affiliates Options",
                  softWrap: true,
                  style: TextStyle(color: Colors.black87, fontSize: 17)),
            ),
          ],
        ),
      ),
      visible:
          snapshot.data!.data!.data!.hideAffiliate == "false" ? true : false,
    );
  }
}
