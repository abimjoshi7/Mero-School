import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension CustomInputDecoration on InputDecoration {
  static InputDecoration loginInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: HexColor.fromHex(bottomNavigationIdealState)),
        borderRadius: BorderRadius.circular(25.7),
      ),
      prefixIcon: Icon(
        Icons.vpn_key,
        color: HexColor.fromHex(bottomNavigationIdealState),
      ),
    );
  }

  static InputDecoration editProfileInputDecoration(
      String hintText, IconData icon) {
    return InputDecoration(
      hintStyle: TextStyle(color: Colors.black),
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: HexColor.fromHex(bottomNavigationIdealState)),
        borderRadius: BorderRadius.circular(25.7),
      ),
      prefixIcon: Icon(
        icon,
        color: HexColor.fromHex(bottomNavigationIdealState),
      ),
    );
  }
}
