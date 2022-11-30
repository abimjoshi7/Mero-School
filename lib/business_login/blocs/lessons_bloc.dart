import 'package:mero_school/data/models/response/save_course_progress_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';

class LessonsBloc {
  late MyNetworkClient _myNetworkClient;

  initBloc() {
    _myNetworkClient = MyNetworkClient();
  }

  Future<SaveCourseProgressResponse> saveCourseProgress(
      String? lessonId, String progress) async {
    var t = await Preference.getString(token);

    SaveCourseProgressResponse response = await _myNetworkClient
        .saveCourseProgress(lessonId, Common.checkNullOrNot(t), progress);
    return response;
  }
}
