import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/animation_image.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

//SignIn/SignUp Screen
class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    WebEngagePlugin.trackScreen(TAG_PAGE_ACCOUNT);

    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimationImage(
            path: ic_do_login,
            width: 150,
          ),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: HexColor.fromHex(colorBlue),
              ),
              child: Text(sign_in),
              onPressed: () {
                Navigator.of(context).pushNamed(login_page);
              },
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: HexColor.fromHex(colorBlue),
              ),
              child: Text(sign_up),
              onPressed: () {
                Navigator.of(context).pushNamed(register_page);
              },
            ),
          )
        ],
      ),
    );
  }
}
