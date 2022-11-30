import 'dart:async';

import 'package:entrance/bloc/bloc.dart';
import 'package:entrance/bloc/response.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/network/my_network_client.dart';

class PackageModelBloc extends Bloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();

  PackageModelBloc() {
    init();
  }

  late StreamController<Response<CategoryModelResponse>>
      _dataCategoryModelController;
  StreamSink<Response<CategoryModelResponse>> get dataCategoryModelSink =>
      _dataCategoryModelController.sink;
  Stream<Response<CategoryModelResponse>> get dataCategoryModelStream =>
      _dataCategoryModelController.stream;

  init() {
    _dataCategoryModelController =
        StreamController<Response<CategoryModelResponse>>();
    fetchCategoryModelData();
  }

  fetchCategoryModelData() async {
    dataCategoryModelSink.add(Response.loading('Getting a Data!'));

    try {
      CategoryModelResponse response =
          await _myNetworkClient.getDataPath<CategoryModelResponse>(
              new CategoryModelResponse(), "categories");



      List<CategoryData> datas  = [];
      CategoryData ioe = CategoryData();
      ioe.id = "1";
      ioe.name= "3 Days Unlimited";
      ioe.numberOfCourses = 10;
      ioe.thumbnail = "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_25.jpg?time=1621007406";


      datas.add(ioe);
      CategoryData iom = CategoryData();
      iom.id = "1";
      iom.name= "1 Months";
      iom.numberOfCourses = 10;
      iom.thumbnail = "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_92.jpg?time=1637925839";


      datas.add(iom);


      CategoryData iost = CategoryData();
      iost.id = "1";
      iost.name= "150 Test";
      iost.numberOfCourses = 10;
      iost.thumbnail = "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_65.jpg?time=1629720574";


      datas.add(iost);


      CategoryData iosts = CategoryData();
      iosts.id = "1";
      iosts.name= "100 Free Mock Test";
      iosts.numberOfCourses = 10;
      iosts.thumbnail = "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_11.jpg?time=1641188977";


      datas.add(iosts);


      response.data = datas;




      print("Response: ${response.data?.length}");

      dataCategoryModelSink.add(Response.completed(response));
    } catch (e) {
      dataCategoryModelSink.add(Response.error(e.toString()));

      print(e);
    }
  }

  @override
  void dispose() {
    _dataCategoryModelController.close();
  }
}
