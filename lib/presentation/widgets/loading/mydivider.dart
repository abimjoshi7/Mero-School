import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';

class MyDivider extends StatelessWidget {
  MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: HexColor.fromHex(bottomNavigationIdealState),
      thickness: 0.2,
    );
  }
}
