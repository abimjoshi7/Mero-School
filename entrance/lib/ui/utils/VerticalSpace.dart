import 'package:flutter/cupertino.dart';

class VSpace extends StatelessWidget {
  var size = 10.0;

  VSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
    );
  }
}
