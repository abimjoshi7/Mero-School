import 'dart:async';

import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/base_bloc.dart';
import 'package:mero_school/main.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';

class MyCartBloc extends BaseBloc {
  StreamController? _dataController;
  StreamController? _dataControllerPrice;
  // MyNetworkClient _myNetworkClient;
  var db = AppDatabase.instance;

  late bool _isStreaming;

  StreamSink<Response<List<MyCartModelData>>> get dataSink =>
      _dataController!.sink as StreamSink<Response<List<MyCartModelData>>>;

  Stream<Response<List<MyCartModelData>>> get dataStream =>
      _dataController!.stream as Stream<Response<List<MyCartModelData>>>;

  initBloc() {
    _dataController =
        StreamController<Response<List<MyCartModelData>>>.broadcast();

    _dataControllerPrice = StreamController<String>.broadcast();
    _isStreaming = true;
    // _myNetworkClient = MyNetworkClient();

    getAllData();
  }

  insertIntoDb(MyCartModelData model) async {
    await db.into(db.myCartModel).insert(model);
  }

  getAllData() async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {



      List<MyCartModelData> model = await  db.select(db.myCartModel).get();

      if (model.isEmpty) {
        if (_isStreaming) dataSink.add(Response.error("No Item In Cart"));
      } else {
        if (_isStreaming) dataSink.add(Response.completed(model));
      }
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error("No Item In Cart"));
      print(e);
    }
  }

  Future<Object> deleteData(MyCartModelData model) async {
    analytics.logEvent(name: REMOVE_FROM_CART, parameters: <String, dynamic>{
      ITEM_ID: model.cartId,
      ITEM_NAME: model.title,
      ITEM_CATEGORY: "course",
      PRICE: model.price,
      VALUE: model.price
    });

    return await (db.delete(db.myCartModel)..where((tbl) => tbl.cartId.equals(model.cartId))).go();

    // await locator<AppDatabase>().deleteCartData(model);

    return "${model.title} removed from cart successfully";
  }

  StreamSink<String> get dataSinkPrice =>
      _dataControllerPrice!.sink as StreamSink<String>;

  Stream<String> get dataStreamPrice =>
      _dataControllerPrice!.stream as Stream<String>;

  updatePrice(double price) async {
    dataSinkPrice.add(price.toString());
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
    _dataControllerPrice?.close();
  }
}
