import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaceHolderLoading extends StatelessWidget {
  final String? loadingMessage;

  PlaceHolderLoading({Key? key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: Column(children: [
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 24,
                      height: 140.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 24,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 24,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 40.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ])),
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 16.0),
                  child: Column(children: [
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 24,
                      height: 140.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 24,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 24,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 40.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ])),
            ],
          )),
    );
  }
}
