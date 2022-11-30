import 'package:flutter/material.dart';
import 'package:mero_school/data/models/response/curriculum_data_res_model.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';

class LessonSectionRepo {
  final _network = MyNetworkClient();

  Future<CurriculumDataResModel> getCurrData(int courseID) async {
    final res = await _network.fetchInitialCurriculumData(courseID);
    return res;
  }
}
