import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/business_login/blocs/my_plan_history_bloc.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/custom_image_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/utils/image_error.dart';

class MyPlanHistoryPage extends StatefulWidget {
  @override
  _MyPlanHistoryPageState createState() => _MyPlanHistoryPageState();
}

class _MyPlanHistoryPageState extends State<MyPlanHistoryPage> {
  late MyPlanHistoryBloc _myTransactionHistoryBloc;

  @override
  void initState() {
    _myTransactionHistoryBloc = MyPlanHistoryBloc();
    _myTransactionHistoryBloc.initBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: HexColor.fromHex(bottomNavigationIdealState)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          logo_no_text,
          height: 38,
          width: 38,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: HexColor.fromHex(bottomNavigationIdealState),
            ),
            onPressed: () {
              _myTransactionHistoryBloc.fetchData();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "My Plans",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: HexColor.fromHex(colorAccent)),
              ),
            ),

            // loadText("Transaction History", "Bank Payments ",1),

            Expanded(
              child: StreamBuilder<Response<AllPlansResponse>>(
                  stream: _myTransactionHistoryBloc.dataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return Loading(
                              loadingMessage: snapshot.data!.message);
                          break;
                        case Status.COMPLETED:
                          var myList = snapshot.data!.data!.data!;
                          return ListView.builder(
                              itemCount: myList.length,
                              itemBuilder: (context, index) {
                                return loadSingleItemCard(myList[index]);
                              });

                          break;
                        case Status.ERROR:
                          return Error(
                            errorMessage: snapshot.data!.message,
                            onRetryPressed: () =>
                                _myTransactionHistoryBloc.fetchData(),
                          );
                          break;
                      }
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _myTransactionHistoryBloc.dispose();
  }

  Widget loadSingleItemCard(AppPlanData model) {
    // var model = data.data.data[index];
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, plans_details_page,
            arguments: <String, AppPlanData>{'model': model});
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(model.plans!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: HexColor.fromHex(bottomNavigationEnabledState),
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: HexColor.fromHex(bottomNavigationIdealState),
                      thickness: 0.2,
                      height: 0.1,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            var dialog = CustomImageDialog(model.thumbnail);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              },
                            );
                          },
                          child: FadeInImage.assetNetwork(
                              image: model.thumbnail.toString(),
                              height: 120,
                              width: 120,
                              placeholder: logo_placeholder,
                              imageErrorBuilder: (_, __, ___) {
                                return ImageError();
                              },
                              fit: BoxFit.fill),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(model.courseDuration.toString(),
                                    style: TextStyle(
                                        color: HexColor.fromHex(
                                            bottomNavigationEnabledState))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${model.subscription != null ? model.subscription!.length.toString() : 0} Subscriptions",
                                    style: TextStyle(
                                        color: HexColor.fromHex(colorAccent))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${model.coursePlan != null ? model.coursePlan!.length.toString().trim() : 0} Courses",
                                    style: TextStyle(
                                        color: HexColor.fromHex(
                                            bottomNavigationEnabledState))),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: HexColor.fromHex(bottomNavigationIdealState),
                      thickness: 0.2,
                      height: 0.1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                      child: Text(
                          model.shortDescription == null
                              ? empty
                              : model.shortDescription!,
                          maxLines: 2,
                          style: TextStyle(
                              color: HexColor.fromHex(
                                  bottomNavigationEnabledState))),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget loadText(String start, String end, int id) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              start,
              style: TextStyle(
                  fontSize: 15,
                  color: HexColor.fromHex(colorDarkRed),
                  fontWeight: FontWeight.w800),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  end,
                  style: TextStyle(color: HexColor.fromHex(colorBlue)),
                ),
                Visibility(
                  visible: id == 3 ? false : true,
                  child: Icon(
                    AntDesign.doubleright,
                    size: 12,
                    color: HexColor.fromHex(colorBlue),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
