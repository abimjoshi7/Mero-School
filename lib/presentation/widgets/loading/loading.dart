import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';

class Loading extends StatelessWidget {
  final String? loadingMessage;

  Loading({Key? key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SpinKitCircle(
          color: HexColor.fromHex(bottomNavigationIdealState),
        ),
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     // Visibility(
      //     //   visible: isLoadingText,
      //     //   child: Text(
      //     //     loadingMessage,
      //     //     textAlign: TextAlign.center,
      //     //     style: TextStyle(
      //     //       color: Colors.black54,
      //     //       fontSize: 24,
      //     //     ),
      //     //   ),
      //     // ),
      //     SizedBox(height: 24),
      //     CircularProgressIndicator(
      //       valueColor: AlwaysStoppedAnimation<Color>(HexColor.fromHex(colorDarkRed)),
      //     ),
      //   ],
      // ),
    );
  }
}
