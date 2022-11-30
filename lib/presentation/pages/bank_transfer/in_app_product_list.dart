import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mero_school/business_login/blocs/in_app_product_list_bloc.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/loading_with_msg.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical_fixed.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';

class InAppProductsList extends StatefulWidget {
  InAppProductsList({Key? key}) : super(key: key);

  @override
  _InAppProductsListState createState() {
    return _InAppProductsListState();
  }
}

class _InAppProductsListState extends State<InAppProductsList>
    with TickerProviderStateMixin {
  @override
  void initState() {
    _bloc = InAppProductListBloc();
    _bloc.initBloc();

    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 5),
    // );
    // controller.repeat(reverse: true);
    //

    super.initState();
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  late InAppProductListBloc _bloc;

  String? productIds;
  String? courseIds;
  String? subscriptionIds;

  Map? _arguments;

  // AnimationController controller;

  bool isSuccess = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    productIds = _arguments!["productId"];

    if (_arguments!.containsKey("courseId")) {
      courseIds = _arguments!["courseId"];
    }

    if (_arguments!.containsKey('subscription')) {
      subscriptionIds = _arguments!['subscription'];
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: HexColor.fromHex(bottomNavigationEnabledState)),
          onPressed: () {
            Navigator.pop(context, isSuccess);
          },
        ),
        title: Image.asset(
          logo_no_text,
          height: 38,
          width: 38,
        ),
      ),
      body: StreamBuilder<Response<bool>>(
          stream: _bloc.availableStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return PlaceHolderLoading();
                  break;

                case Status.COMPLETED:
                  if (snapshot.data!.data == false) {
                    return Error(
                      errorMessage:
                          "The store cannot be reached or accessed. Update the UI accordingly.",
                      isDisplayButton: false,
                    );
                  } else {
                    // if(courseIds == null){
                    //   courseIds = subscriptionIds;
                    // }

                    if (productIds!.isNotEmpty) {
                      _bloc.fetchData(productIds!);
                    }

                    _bloc.fetchPurchases();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          StreamBuilder<Response<bool>>(
                              stream: _bloc.popupStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.status ==
                                      Status.COMPLETE_MESSAGE) {
                                    isSuccess = true;
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      ToastHelper.showLong(
                                          "${snapshot.data!.message}");

                                      Navigator.pop(context, isSuccess);
                                    });
                                  }

                                  if (snapshot.data!.status == Status.ERROR) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Error(
                                        errorMessage: snapshot.data!.message,
                                        isDisplayButton: false,
                                      ),
                                    );
                                  }

                                  return Visibility(
                                      visible: snapshot.data!.status ==
                                              Status.LOADING
                                          ? true
                                          : false,
                                      child: LoadingWithMessage(
                                        loadingMessage: snapshot.data!.message,
                                      ));
                                  // child:  LinearProgressIndicator(
                                  //   value: controller.value,
                                  //   semanticsLabel: 'Linear progress indicator',
                                  // ));
                                } else {
                                  return Container();
                                }
                              }),

                          StreamBuilder<Response<bool>>(
                              stream: _bloc.popupStream,
                              builder: (context, snapshot) {
                                bool isLoading = false;

                                if (snapshot.hasData &&
                                    snapshot.data!.status == Status.LOADING) {
                                  isLoading = true;
                                }
                                return StreamBuilder<Response<List<IAPItem>>>(
                                    stream: _bloc.dataStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        switch (snapshot.data!.status) {
                                          case Status.LOADING:
                                            return PlaceHolderLoadingVerticalFixed();
                                            break;

                                          case Status.COMPLETED:
                                            {
                                              if (snapshot.data!.data!.length ==
                                                  0) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Error(
                                                    errorMessage:
                                                        'Products currently unavailable',
                                                    isDisplayButton: false,
                                                  ),
                                                );
                                              }

                                              return ListView.builder(
                                                itemCount:
                                                    snapshot.data!.data!.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, pos) {
                                                  var item =
                                                      snapshot.data!.data![pos];

                                                  return Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Card(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                item.title!,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Text(
                                                                item.description!,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${item.currency} ${item.price}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          isLoading
                                                                              ? null
                                                                              : () {
                                                                                  print("---------- Buy Item Button Pressed");
                                                                                  _requestPurchase(item);
                                                                                },
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.resolveWith<Color>(
                                                                          (Set<MaterialState>
                                                                              states) {
                                                                            var color;
                                                                            if (isLoading) {
                                                                              color = secondColor;
                                                                            } else {
                                                                              color = colorAccent;
                                                                            }
                                                                            if (states.contains(MaterialState.pressed))
                                                                              return HexColor.fromHex(color);
                                                                            return HexColor.fromHex(color); // Use the component's default.
                                                                          },
                                                                        ),
                                                                      ),
                                                                      child: Text(
                                                                          'Buy Item')),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }

                                          case Status.ERROR:
                                            {
                                              return Error(
                                                errorMessage:
                                                    "${snapshot.data!.message}",
                                                isDisplayButton: false,
                                              );
                                            }
                                        }
                                      } else {
                                        return Container();
                                      }

                                      return Container();
                                    });
                              }),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text("Pending Purchases"),
                          // ),
                          //
                          // StreamBuilder<Response<List<PurchasedItem>>>(
                          //     stream: _bloc.purchasedStream,
                          //     builder: (context, snapshot) {
                          //
                          //
                          //       if(snapshot.hasData){
                          //
                          //         switch (snapshot.data.status) {
                          //           case Status.LOADING:
                          //             return PlaceHolderLoadingVerticalFixed();
                          //             break;
                          //
                          //           case Status.COMPLETED:{
                          //
                          //             if(snapshot.data.data.length == 0){
                          //               return Error(errorMessage: 'Products currently unavailable',
                          //                 isDisplayButton: false,
                          //               );
                          //             }
                          //
                          //
                          //             return ListView.builder(
                          //               itemCount: snapshot.data.data.length,
                          //               shrinkWrap: true,
                          //               itemBuilder: (context, pos){
                          //
                          //
                          //                 var item = snapshot.data.data[pos];
                          //
                          //
                          //
                          //
                          //                 return Container(
                          //                   margin: EdgeInsets.symmetric(vertical:10),
                          //                   child: Card(
                          //
                          //                     child: Padding(
                          //                       padding: const EdgeInsets.all(16.0),
                          //                       child: Container(
                          //                         child: Column(
                          //                           children: [
                          //
                          //                             Text(
                          //                               item.productId,
                          //                               style: TextStyle(
                          //                                 fontSize: 18.0,
                          //                                 color: Colors.black,
                          //                               ),
                          //                             ),
                          //
                          //                             SizedBox(height: 8,),
                          //
                          //                             Text(
                          //                               item.transactionId,
                          //                               style: TextStyle(
                          //                                 fontSize: 15.0,
                          //                                 color: Colors.black,
                          //                               ),
                          //                             ),
                          //
                          //                             SizedBox(height: 8,),
                          //
                          //
                          //                             Row(
                          //
                          //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                               children: [
                          //                                 Text(
                          //                                   "",
                          //                                   style: TextStyle(
                          //                                     fontSize: 15.0,
                          //                                     color: Colors.black,
                          //                                   ),
                          //                                 ),
                          //
                          //                                 SizedBox(width: 8,),
                          //                                 ElevatedButton(
                          //
                          //                                     onPressed: () {
                          //                                       print("---------- Buy Item Button Pressed");
                          //                                       _validatePurchase(item);
                          //                                     },
                          //                                     child:  Text('Validate Item')
                          //                                 ),
                          //
                          //                               ],
                          //                             ),
                          //
                          //                           ],
                          //
                          //                         ),
                          //
                          //
                          //                       ),
                          //                     ),
                          //                   ),
                          //
                          //                 );
                          //               },
                          //             );
                          //           }
                          //
                          //           case Status.ERROR:{
                          //             return  Error(
                          //               errorMessage: "${snapshot.data.message}",
                          //               isDisplayButton: false,
                          //             );
                          //           }
                          //         }
                          //
                          //
                          //
                          //       }else{
                          //
                          //         return Container(
                          //         );
                          //       }
                          //
                          //
                          //     }
                          // ),
                        ],
                      ),
                    );
                  }

                  break;
              }
            }

            return Container();
          }),
    );
  }

  void _validatePurchase(PurchasedItem item) {}

  void _requestPurchase(IAPItem item) {
    _bloc.requestPurchase(item, courseIds);
    // final PurchaseParam purchaseParam = PurchaseParam(productDetails: item);
    // InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
  }
}
