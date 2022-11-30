import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaceHolderLoadingGrid extends StatelessWidget {
  final String? loadingMessage;

  PlaceHolderLoadingGrid({Key? key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: SingleChildScrollView(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, __) {
                  return Column(children: [
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 20,
                      height: 140.0,
                      color: Colors.white,
                    ),

                    // const Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 8.0),
                    // ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 100.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ]);
                }),
          )),
    );
  }
}
