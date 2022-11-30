import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/images.dart';

class ImageError extends StatelessWidget {
  double? size = 75;

  ImageError({this.size});

  @override
  Widget build(BuildContext context) {
    return new Icon(
      Icons.image,
      size: size,
      color: Colors.black12,
    );
  }
}

class ImageErrorLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: new Image.asset(
        logo_placeholder,
      ),
    );
  }
}

class ImageErrorBg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 100,
      child: new Image.asset(
        logo_placeholder,
      ),
    );
  }
}
