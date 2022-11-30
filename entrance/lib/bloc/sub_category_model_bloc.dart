import 'dart:async';

import 'package:entrance/bloc/bloc.dart';
import 'package:entrance/bloc/response.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/network/my_network_client.dart';
import 'package:rxdart/rxdart.dart';

class SubCategoryModelBloc extends Bloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();

  SubCategoryModelBloc() {
    init();
  }

  late StreamController<CategoryData> selectedCategory;

  late StreamController<Response<CategoryModelResponse>>
      _dataCategoryModelController;
  StreamSink<Response<CategoryModelResponse>> get dataCategoryModelSink =>
      _dataCategoryModelController.sink;
  Stream<Response<CategoryModelResponse>> get dataCategoryModelStream =>
      _dataCategoryModelController.stream;

  //BehaviorSubject<Response<TopCourseResponse>>();
  init() {
    selectedCategory = BehaviorSubject<CategoryData>();

    _dataCategoryModelController =
        BehaviorSubject<Response<CategoryModelResponse>>();
    selectedCategory = BehaviorSubject<CategoryData>();
  }

  selectCategory(CategoryData response) {
    selectedCategory.sink.add(response);
    fetchCategoryModelData("${response.id}");
  }

  fetchCategoryModelData(String id) async {
    print("---> $id");

    dataCategoryModelSink.add(Response.loading('Getting a Data!'));

    try {
      CategoryModelResponse response =
          await _myNetworkClient.getDataPath<CategoryModelResponse>(
              new CategoryModelResponse(), "categories");

      List<CategoryData> datas  = [];
      CategoryData ioe = CategoryData();
      ioe.id = "1";
      ioe.name= "Physics";
      ioe.numberOfCourses = 10;
      ioe.thumbnail = "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_25.jpg?time=1621007406";


      datas.add(ioe);
      CategoryData iom = CategoryData();
      iom.id = "1";
      iom.name= "Chemistry";
      iom.numberOfCourses = 10;
      iom.thumbnail = "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_92.jpg?time=1637925839";


      datas.add(iom);


      CategoryData iost = CategoryData();
      iost.id = "1";
      iost.name= "Maths";
      iost.numberOfCourses = 10;
      iost.thumbnail = "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_65.jpg?time=1629720574";


      datas.add(iost);


      CategoryData iosts = CategoryData();
      iosts.id = "1";
      iosts.name= "Drawing";
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
    selectedCategory.close();
  }
}
