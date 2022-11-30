import 'package:flutter/material.dart';

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
