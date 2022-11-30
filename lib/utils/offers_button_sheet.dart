
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mero_school/business_login/blocs/reviews_bloc.dart';
import 'package:mero_school/data/models/response/related_plan_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/widgets/loading/mydivider.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:shimmer/shimmer.dart';

import 'image_error.dart';

class OffersBottomSheets extends StatefulWidget {
  Function(String)? callback;
  RelatedPlanResponse? systemSettingsResponse;
  String? courseId;

  // BuildContext popContext;
  // payment_method(this.popContext, this.callback);

  OffersBottomSheets(
      {Key? key, this.courseId, this.callback, this.systemSettingsResponse})
      : super(key: key);

  @override
  _OffersBottomSheetsState createState() {
    return _OffersBottomSheetsState();
  }
}

class _OffersBottomSheetsState extends State<OffersBottomSheets>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: 0.7);

    _splashBloc = ReviewsBloc();
    _splashBloc.initBloc();

    if (widget.systemSettingsResponse == null) {
      _splashBloc.fetchRelatedPlan(widget.courseId);
    } else {
      _splashBloc.updateRelatedPlan(widget.systemSettingsResponse);
    }

    super.initState();
  }

  late ReviewsBloc _splashBloc;

  @override
  void dispose() {
    _splashBloc.dispose();
    _pageController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<Response<RelatedPlanResponse>>(
            stream: _splashBloc.relatedPlanStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    // return loadImage();
                    return mainVeiwLoader(context);
                    break;
                  case Status.COMPLETED:
                    // _splashBloc.saveData(snapshot.data!.data!).then((value) {});

                    return mainVeiw(context, snapshot.data!.data);

                    break;
                  case Status.ERROR:
                    var showLong =
                        ToastHelper.showLong(snapshot.data!.message!);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "No Any Associated plan available. Please Try Again Later.",
                          textAlign: TextAlign.center),
                    );

                    // return  mainVeiw(context,null);

                    break;
                }
              }
              return loadImage();
            }));
  }

  Widget loadImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: Lottie.asset('assets/progress_two.json'),
          ),
          Text("fetching related plans ..."),
        ],
      ),
    );
  }

  Widget mainVeiwLoader(BuildContext context) {
    return SafeArea(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                child: PageView.builder(
                  itemCount: 3,
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        // child: Column(
                        //   mainAxisSize: MainAxisSize.max,
                        //   children: [
                        //
                        //     Text("Hello: Index $index")
                        //   ],
                        // ),

                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16.0),
                                    topLeft: Radius.circular(16.0),
                                    bottomRight: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0)),
                                child: Container(
                                  // child: FadeInImage.assetNetwork(image: model.thumbnail,
                                  //     placeholder: logo_placeholder,
                                  //     height: 140,
                                  //     width: MediaQuery.of(context).size.width,
                                  //     fit: BoxFit.fill,
                                  //     imageErrorBuilder: (_,__,___){
                                  //       return ImageError(size: 140,);
                                  //     },
                                  // ),

                                  child: Container(
                                    height: 160,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                )),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            MyDivider(),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            MyDivider(),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            MyDivider(),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mainVeiw(BuildContext context, RelatedPlanResponse? data) {
    return SafeArea(
      child: PageView.builder(
        itemCount: data?.data?.length,
        controller: _pageController,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.callback!("${data?.data?[index].id}");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // child: Column(
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: [
                  //
                  //     Text("Hello: Index $index")
                  //   ],
                  // ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.0),
                              topLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0)),
                          child: Container(
                            // child: FadeInImage.assetNetwork(image: model.thumbnail,
                            //     placeholder: logo_placeholder,
                            //     height: 140,
                            //     width: MediaQuery.of(context).size.width,
                            //     fit: BoxFit.fill,
                            //     imageErrorBuilder: (_,__,___){
                            //       return ImageError(size: 140,);
                            //     },
                            // ),

                            child: CachedNetworkImage(
                                placeholder: (_, __) {
                                  return Image.asset(logo_placeholder);
                                },
                                imageUrl: "${data?.data?[index].thumbnail}",
                                height: 160,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                                errorWidget: (_, __, ___) {
                                  return ImageError(size: 140);
                                }),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${data?.data?[index].title}"),
                      ),

                      MyDivider(),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${data?.data?[index].label}",
                                style: TextStyle(
                                    color: HexColor.fromHex(
                                        bottomNavigationEnabledState))),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${data?.data?[index].price}",
                                style: TextStyle(
                                    color: HexColor.fromHex(colorAccent))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      MyDivider(),
                      SizedBox(
                        height: 5,
                      ),
                      Text("  ${data?.data?[index].courses?.length} Courses",
                          style:
                              TextStyle(color: HexColor.fromHex(colorAccent))),
                      // MyDivider(),
                      SizedBox(
                        height: 5,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text("${data?.data?[index].shortDescription}",
                      //     overflow: TextOverflow.ellipsis,
                      //     maxLines: 4,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
