import 'dart:async';

import 'package:mero_school/data/models/request/my_transaction_history_request.dart';
import 'package:mero_school/data/models/response/entrance_config.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:rxdart/rxdart.dart';

class EntranceWebBloc {
  late MyNetworkClient _myNetworkClient;

  EntranceWebBloc() {
    initBloc();
  }

  late bool _isStreaming;

  initBloc() {
    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;

    _dataEntranceConfigController =
        BehaviorSubject<Response<Entrance_config>>();
    // fetchEntranceData();
  }






  StreamController? _dataEntranceConfigController;

  StreamSink<Response<Entrance_config>> get dataEntranceConfigSink =>
      _dataEntranceConfigController!.sink
          as StreamSink<Response<Entrance_config>>;

  Stream<Response<Entrance_config>> get dataEntranceConfigStream =>
      _dataEntranceConfigController!.stream
          as Stream<Response<Entrance_config>>;

  //add this in init() method
  //    _dataEntranceConfigController = StreamController<Response<EntranceConfigResponse>>();

  //add this to dispose
  //    _dataEntranceConfigController?.close();

  fetchEntranceData({token: String}) async {
    //for all plans

    // _dataEntranceConfigController.add(Response.loading('Getting a Data!'));

    GeneralTokenRequest request = GeneralTokenRequest(authToken: token);


    try {
      Entrance_config response =
          await _myNetworkClient.getEntranceConfig(request);
      if (response.status! && response.data!.url!.isNotEmpty) {

        print("here update");
        _dataEntranceConfigController!.add(Response.completed(response));


      } else {
        print("here updateelse ");

        // _dataEntranceConfigController.add(Response.error(response.message));

      }
    } catch (e) {

      print("here update $e");

      // _dataEntranceConfigController.add(Response.error(e.toString()));

    }
    // }else{
    //   // _dataEntranceConfigController.add(Response.error("Login to view entrance"));
    //
    //   print("fetchining: not token exit");
    //
    // }
  }


  dispose() {
    _isStreaming = false;

    _dataEntranceConfigController?.close();
  }
}
