import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/business_login/blocs/my_bank_history_bloc.dart';
import 'package:mero_school/data/models/response/my_bank_history_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/widgets/custom_image_dialog.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical.dart';
import 'package:mero_school/presentation/widgets/transaction_history_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/utils/toast_helper.dart';

class MyBankHistoryPage extends StatefulWidget {
  @override
  _MyBankHistoryPageState createState() => _MyBankHistoryPageState();
}

class _MyBankHistoryPageState extends State<MyBankHistoryPage> {
  late MyBankHistoryBloc _myTransactionHistoryBloc;

  @override
  void initState() {
    _myTransactionHistoryBloc = MyBankHistoryBloc();
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
                "Bank Payment History ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: HexColor.fromHex(colorAccent)),
              ),
            ),

            // loadText("Transaction History", "Bank Payments ",1),

            Expanded(
              child: StreamBuilder<Response<MyBankHistoryResponse>>(
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

  Widget loadSingleItemCard(DataListBean any) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          ToastHelper.showShort("Buy")

          // // code on continue comes here
        };

    String? displayTitle = "";

    if (any.course != null && any.course!.isNotEmpty) {
      displayTitle = any.course;
    }

    if (any.plans != null && any.plans!.isNotEmpty) {
      displayTitle = any.plans;
    }

    var dialog = TransactionHistoryDialog("Mero School",
        "Continue Purchase Course:\n$displayTitle ?", continueCallBack);
    return GestureDetector(
      onTap: () {
        var dialog = CustomImageDialog(any.image);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          },
        );

        // if(any.status != "SUCCESS"){
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return dialog;
        //     },
        //   );
        // }
      },
      child: Card(
        margin: EdgeInsets.all(5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),

        //     itemView.txtPrice.text = any.deposited_amount
        // itemView.txtState.text = any.status
        //

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ref Id: " + any.id! + " [${any.depositedType}]",
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor.fromHex(bottomNavigationEnabledState)),
                  ),
                  Icon(
                    Feather.eye,
                    size: 18,
                    color: HexColor.fromHex(colorBlue),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "$displayTitle",
                style: TextStyle(
                    color: HexColor.fromHex(bottomNavigationEnabledState)),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                  "${"Deposited By: "} ${any.depositerName} (${any.mobileNumber})",
                  style: TextStyle(
                      color: HexColor.fromHex(bottomNavigationIdealState))),
              SizedBox(
                height: 4,
              ),
              Text(
                  "Deposited Account number : ${any.accountName} (${any.depositedAccountNumer}), ${any.bankName} (${any.bankBranch} Branch)",
                  style: TextStyle(
                      color: HexColor.fromHex(bottomNavigationIdealState))),
              SizedBox(
                height: 16,
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
                            text: any.depositedDate,
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
                            text: "${any.depositedAmount}",
                            style:
                                TextStyle(color: HexColor.fromHex(colorBlue))),
                      ],
                    ),
                  ),
                  statusWidget(any.status!),
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
  }

  statusWidget(String status) {
    switch (status.toUpperCase()) {
      case "SUCCESS":
      case "APPROVED":
        return RichText(
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
                  text: status,
                  style: TextStyle(color: HexColor.fromHex(firstColor))),
            ],
          ),
        );
        break;
      case "FAILED":
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
                  text: status,
                  style: TextStyle(color: HexColor.fromHex(colorAccent))),
            ],
          ),
        );
        break;
      case "PENDING":
        return RichText(
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
        );
        break;
      case "CANCELLED":
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
    return null;
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
