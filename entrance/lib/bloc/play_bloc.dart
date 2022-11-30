import 'dart:async';
import 'dart:collection';

import 'package:entrance/bloc/bloc.dart';
import 'package:entrance/network/my_network_client.dart';
import 'package:rxdart/rxdart.dart';

class PlayBloc extends Bloc {
  HashMap userAnswersMap = new HashMap<int, int>();

  MyNetworkClient _myNetworkClient = MyNetworkClient();

  PlayBloc() {
    init();
  }

  addUserAnswer(int pos, int option) {
    userAnswersMap[pos] = option;
  }

  int getUserAnswer(int pos) {
    if (userAnswersMap.containsKey(pos)) {
      return userAnswersMap[pos];
    }
    return -1;
  }

  late StreamController<int> positionController;

  StreamSink<int> get dataEntranceModelSink => positionController.sink;
  Stream<int> get dataEntranceModelStream => positionController.stream;

  init() {
    positionController = BehaviorSubject<int>();
  }

  @override
  void dispose() {
    positionController.close();
  }
}
