import 'dart:async';

import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/data/models/response/my_wishlist_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';

import 'base_bloc.dart';

class MyWishListBloc extends BaseBloc {
  StreamController? _dataController;
  late bool _isStreaming;

  StreamSink<Response<MyWishlistResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<MyWishlistResponse>>;

  Stream<Response<MyWishlistResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<MyWishlistResponse>>;

  initBloc() {
    _dataController = StreamController<Response<MyWishlistResponse>>();
    myNetworkClient = MyNetworkClient();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      var t = await Preference.getString(token);

      MyWishlistResponse response =
          await myNetworkClient.fetchMyWishList(Common.checkNullOrNot(t));
      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
  }
}
