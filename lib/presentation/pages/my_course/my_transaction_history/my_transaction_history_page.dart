import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/my_cart_bloc.dart';
import 'package:mero_school/business_login/blocs/my_transaction_history_bloc.dart';
import 'package:mero_school/business_login/blocs/plans_subscription_bloc.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical.dart';
import 'package:mero_school/presentation/widgets/transaction_history_dialog.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/data/models/response/my_transaction_history_response.dart';
import 'package:mero_school/presentation/widgets/error.dart';

class MyTransactionHistoryPage extends StatefulWidget {
  @override
  _MyTransactionHistoryPageState createState() =>
      _MyTransactionHistoryPageState();
}

class _MyTransactionHistoryPageState extends State<MyTransactionHistoryPage> {
  late MyTransactionHistoryBloc _myTransactionHistoryBloc;
  late MyCartBloc _myCartBloc;
  List<NotificationModelData>? myCartList;
  late AppProgressDialog _progressDialog;
  late PlansSubscriptionBloc _plansSubscriptionBloc;

  @override
  void initState() {
    _myTransactionHistoryBloc = MyTransactionHistoryBloc();
    _myTransactionHistoryBloc.initBloc();

    _myCartBloc = MyCartBloc();
    _myCartBloc.initBloc();

    _plansSubscriptionBloc = PlansSubscriptionBloc();
    _plansSubscriptionBloc.initBloc();

    _progressDialog = new AppProgressDialog(context);

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
            loadText("Transaction History", "Bank Payments ", 1),
            Expanded(
              child: StreamBuilder<Response<MyTransactionHistoryResponse>>(
                  stream: _myTransactionHistoryBloc.dataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return Center(child: PlaceHolderLoadingVertical());
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

  void smartCheckOut(Data model) {
    print("Model: ${model.toJson().toString()}");

    _progressDialog.show();

    if (model.courseId!.isNotEmpty) {
      _myCartBloc
          .smartCoursePayment(
              model.course, model.courseId, model.amount, "", "course")
          .then((value) {
        _progressDialog.hide();

        Navigator.of(context)
            .pushNamed(smart_payment_page, arguments: <String, dynamic>{
          'paymentUrl': value.data!.paymentProceed,
          'carts': [],
          'subscription_id': '',
          'course_id': model.courseId
        }).then((value) {
          if (value.toString().toLowerCase() == "success") {
            _myTransactionHistoryBloc.fetchData();
          }
        });
      });
    } else {
      _plansSubscriptionBloc
          .smartCoursePayment(
        model.plan,
        model.subscriptionId,
        model.amount,
        model.planVilid,
        "plan",
      )
          .then((value) {
        _progressDialog.hide();

        Navigator.of(context)
            .pushNamed(smart_payment_page, arguments: <String, dynamic>{
          'paymentUrl': value.data!.paymentProceed,
          'subscription_id': '${model.id}',
          'plan_id': model.id,
          'package_name': model.package,
          'plan_name': model.plan,
          'package_id': int.parse(model.packageId!),
          'enrolled_status': model.enrolledStatus,
          'price': int.parse(model.amount!),
          'validity': int.parse(model.planVilid!),
          'no_of_course': model.noOfCourse,
          'retry': true
        }).then((value) {
          if (value.toString().toLowerCase() == "success") {
            _myTransactionHistoryBloc.fetchData();
          }
        });
      });
    }
  }

  Widget loadSingleItemCard(Data model) {
    var displayTilte = "";

    if (model.course != null && model.course!.isNotEmpty) {
      displayTilte = "Course: " + model.course!;
    }

    if (model.plan != null && model.plan!.isNotEmpty) {
      displayTilte = "Plan: " + model.plan!;
    }

    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          smartCheckOut(model),

          // // code on continue comes here
        };
    var dialog = TransactionHistoryDialog("Mero School",
        "Continue Purchase :\n${model.course} ?", continueCallBack);
    return GestureDetector(
      onTap: () {
        if (model.status != "SUCCESS") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            },
          );
        }
      },
      child: Card(
        margin: EdgeInsets.all(5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ref Id: ${model.refId} (${model.agent})",
                style: TextStyle(
                    color: HexColor.fromHex(bottomNavigationEnabledState)),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(displayTilte,
                  style: TextStyle(
                      color: HexColor.fromHex(bottomNavigationIdealState))),
              SizedBox(
                height: 12,
              ),


              (model.couponAmount?.isEmpty == true ) ?
              SizedBox():
              Column(
                children: [
                  Text(model.couponAmount.toString(),
                      style: TextStyle(
                          color: HexColor.fromHex(colorAccent))),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),



              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            MaterialCommunityIcons.calendar_range,
                            size: 14,
                            color: HexColor.fromHex(colorAccent),
                          ),
                        ),
                        WidgetSpan(child: Text(" ")),
                        TextSpan(
                            text: "${model.transactionDate}",
                            style: TextStyle(
                                color: HexColor.fromHex(colorAccent))),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            SimpleLineIcons.tag,
                            size: 14,
                            color: HexColor.fromHex(colorBlue),
                          ),
                        ),
                        WidgetSpan(child: Text(" ")),
                        TextSpan(
                            text: "Rs ${model.amount}",
                            style:
                                TextStyle(color: HexColor.fromHex(colorBlue))),
                      ],
                    ),
                  ),
                  statusWidget(model.status!),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _myTransactionHistoryBloc.dispose();
    super.dispose();
  }

  statusWidget(String status) {
    switch (status.toUpperCase()) {
      case "SUCCESS":
        return Flexible(
          child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    AntDesign.checkcircle,
                    size: 14,
                    color: HexColor.fromHex(firstColor),
                  ),
                ),
                WidgetSpan(child: Text(" ")),
                TextSpan(
                    text: '$status',
                    style: TextStyle(color: HexColor.fromHex(firstColor))),
              ],
            ),
          ),
        );
        break;
      case "FAILED":
        return Flexible(
          child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    AntDesign.minuscircle,
                    size: 14,
                    color: HexColor.fromHex(secondColor),
                  ),
                ),
                WidgetSpan(child: Text(" ")),
                TextSpan(
                    text: status,
                    style: TextStyle(color: HexColor.fromHex(colorAccent))),
              ],
            ),
          ),
        );
        break;
      case "PENDING":
        return Flexible(
          child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Feather.info,
                    size: 14,
                    color: HexColor.fromHex(colorBlue),
                  ),
                ),
                WidgetSpan(child: Text(" ")),
                TextSpan(
                    text: status,
                    style: TextStyle(color: HexColor.fromHex(colorBlue))),
              ],
            ),
          ),
        );
        break;
      case "CANCELLED":
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  AntDesign.minuscircle,
                  size: 14,
                  color: HexColor.fromHex(secondColor),
                ),
              ),
              WidgetSpan(child: Text(" ")),
              TextSpan(
                  text: status,
                  style: TextStyle(color: HexColor.fromHex(colorAccent))),
            ],
          ),
        );
        break;

      default:
        return RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  AntDesign.minuscircle,
                  size: 14,
                  color: HexColor.fromHex(secondColor),
                ),
              ),
              WidgetSpan(child: Text(" ")),
              TextSpan(
                  text: "CANCELLED",
                  style: TextStyle(color: HexColor.fromHex(colorAccent))),
            ],
          ),
        );
        break;
    }
    return Container();
  }

  Widget loadText(String start, String end, int id) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            start,
            style: TextStyle(
                fontSize: 15,
                color: HexColor.fromHex(colorDarkRed),
                fontWeight: FontWeight.w800),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, bank_transfer_history_page);
            },
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
