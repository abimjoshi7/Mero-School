import 'dart:async';

import 'package:entrance/bloc/bloc.dart';
import 'package:entrance/bloc/response.dart';
import 'package:entrance/network/my_network_client.dart';

import '../data/entrance_response_model.dart';

class EntranceModelBloc extends Bloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();

  EntranceModelBloc() {
    init();
  }

  late StreamController<Response<EntranceModelResponse>>
      _dataEntranceModelController;
  StreamSink<Response<EntranceModelResponse>> get dataEntranceModelSink =>
      _dataEntranceModelController.sink;
  Stream<Response<EntranceModelResponse>> get dataEntranceModelStream =>
      _dataEntranceModelController.stream;

  init() {
    _dataEntranceModelController =
        StreamController<Response<EntranceModelResponse>>();
    fetchEntranceModelData();
  }

  fetchEntranceModelData() async {
    dataEntranceModelSink.add(Response.loading('Getting a Data!'));

    try {
      EntranceModelResponse response =
          await _myNetworkClient.getDataPath<EntranceModelResponse>(
              new EntranceModelResponse(), "categories");

      dataEntranceModelSink.add(Response.completed(response));
    } catch (e) {
      dataEntranceModelSink.add(Response.error(e.toString()));

      print(e);
    }
  }

  @override
  void dispose() {
    _dataEntranceModelController.close();
  }
}
