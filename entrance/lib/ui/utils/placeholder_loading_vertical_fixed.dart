import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class PlaceHolderLoadingVerticalFixed extends StatefulWidget {
  String? loadingMessage;

  PlaceHolderLoadingVerticalFixed({Key? key, this.loadingMessage})
      : super(key: key);

  @override
  _PlaceHolderLoadingVerticalFixedState createState() =>
      _PlaceHolderLoadingVerticalFixedState();
}

class _PlaceHolderLoadingVerticalFixedState
    extends State<PlaceHolderLoadingVerticalFixed> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 12,
                itemBuilder: (_, __) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
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
                        )
                      ],
                    ),
                  );
                }),
          ),
        ));
  }
}
