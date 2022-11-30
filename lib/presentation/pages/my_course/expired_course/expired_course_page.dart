import 'package:flutter/material.dart';
import 'package:mero_school/business_login/blocs/expired_course_bloc.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_grid.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/data/models/response/my_course_response.dart';
import 'package:mero_school/presentation/widgets/error.dart';

class ExpiredCoursePage extends StatefulWidget {
  @override
  _ExpiredCoursePageState createState() => _ExpiredCoursePageState();
}

class _ExpiredCoursePageState extends State<ExpiredCoursePage> {
  late ExpiredCourseBloc expiredCourseBloc;

  @override
  void initState() {
    expiredCourseBloc = ExpiredCourseBloc();
    expiredCourseBloc.initBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: HexColor.fromHex(bottomNavigationEnabledState)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          logo_no_text,
          height: 38,
          width: 38,
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Expired Courses",
                    style: TextStyle(
                        color: HexColor.fromHex(colorDarkRed),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<Response<MyCourseResponse>>(
                stream: expiredCourseBloc.dataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return PlaceHolderLoadingGrid();
                        break;
                      case Status.COMPLETED:
                        var myList = snapshot.data!.data!.data!;

                        return GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            padding: EdgeInsets.all(8),
                            children: List.generate(myList.length, (index) {
                              return loadCardItem(myList[index]);
                            }));

                        break;
                      case Status.ERROR:
                        return Error(
                          errorMessage: snapshot.data!.message,
                          onRetryPressed: () => expiredCourseBloc.fetchData(),
                        );
                        break;
                    }
                  }
                  return Container();
                }),
          )
        ],
      ),
    );
  }

  Widget loadCardItem(Data model) {
    var completion = 0.0;
    if (model.completion != null) {
      completion = model.completion! / 100.toDouble();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, course_details,
              arguments: <String, String?>{
                'course_id': model.id,
                'title': model.title,
                'price': model.price,
                'shareableLink': model.shareableLink,
                'thumbnail': model.thumbnail,
                'enrollment': model.totalEnrollment.toString(),
                'video_url': model.videoUrl,
              });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(0.0)),
                  child: Container(
                    child: Image.network(model.thumbnail!,
                        height: 95,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.title == null ? empty : model.title!.toUpperCase(),
                  style: TextStyle(
                      color: HexColor.fromHex(bottomNavigationEnabledState)),
                  textAlign: TextAlign.center,
                ),
              ),

              Column(
                children: [
                  Text(
                    "Exp: ${model.expDate}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.black12,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          HexColor.fromHex(bottomNavigationEnabledState)),
                      value: completion,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${model.completion}% Completed",
                      style: TextStyle(
                          color: HexColor.fromHex(darkNavyBlue), fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              )

              // SmoothStarRating(
              //     rating: model.rating.toDouble(),
              //     isReadOnly: true,
              //     size: 12,
              //     color: HexColor.fromHex(colorGolden),
              //     borderColor: HexColor.fromHex(bottomNavigationIdealState)),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    expiredCourseBloc.dispose();
    super.dispose();
  }
}
