import 'dart:async';

import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/data/models/response/my_transaction_history_response.dart';

import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/data/models/request/my_transaction_history_request.dart';
import 'package:rxdart/subjects.dart';

class MyTransactionHistoryBloc {
  late MyNetworkClient _myNetworkClient;
  StreamController? _dataController;
  late bool _isStreaming;

  StreamSink<Response<MyTransactionHistoryResponse>> get dataSink =>
      _dataController!.sink
          as StreamSink<Response<MyTransactionHistoryResponse>>;

  Stream<Response<MyTransactionHistoryResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<MyTransactionHistoryResponse>>;

  initBloc() {
    _dataController = BehaviorSubject<Response<MyTransactionHistoryResponse>>();
    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      var t = await Preference.getString(token);

      GeneralTokenRequest request =
          GeneralTokenRequest(authToken: Common.checkNullOrNot(t));
      MyTransactionHistoryResponse response =
          await _myNetworkClient.myTransactionHistory(request);
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
