import 'dart:async';

import 'package:entrance/bloc/bloc.dart';
import 'package:entrance/bloc/response.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/network/my_network_client.dart';
import 'package:rxdart/rxdart.dart';

class CategoryModelBloc extends Bloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();

  CategoryModelBloc() {
    init();
  }

  late StreamController<Response<CategoryModelResponse>>
      _dataCategoryModelController;
  StreamSink<Response<CategoryModelResponse>> get dataCategoryModelSink =>
      _dataCategoryModelController.sink;
  Stream<Response<CategoryModelResponse>> get dataCategoryModelStream =>
      _dataCategoryModelController.stream;




    late StreamController<List<String>> _dataCarousleController;

    StreamSink<List<String>> get dataCarousleSink => _dataCarousleController.sink;

    Stream<List<String>> get dataCarousleStream => _dataCarousleController.stream;

     //add this in init() method
     //    _dataCarousleController = StreamController<Response<CarousleResponse>>();

      //add this to dispose
      //    _dataCarousleController?.close();








  init() {
    _dataCategoryModelController =
        StreamController<Response<CategoryModelResponse>>();

    _dataCarousleController = BehaviorSubject<List<String>>();
    fetchCategoryModelData();
  }

  fetchCategoryModelData() async {
    dataCategoryModelSink.add(Response.loading('Getting a Data!'));

    try {
      CategoryModelResponse response =
          await _myNetworkClient.getDataPath<CategoryModelResponse>(
              new CategoryModelResponse(), "categories");

      print("Response: ${response.data?.length}");

      List<CategoryData> datas  = [];


      ///// id : "1"
      // /// code : "c0123534e9"
      // /// name : "Class 10"
      // /// parent : "0"
      // /// slug : "class-10"
      // /// date_added : "1612310400"
      // /// last_modified : "1633371300"
      // /// font_awesome_class : "fas fa-chess"
      // /// thumbnail : "https://demo.mero.school/uploads/thumbnails/category_thumbnails/103388dd3361eec20e487bc2b03f06d5.jpg"
      // /// number_of_courses : 10

      CategoryData ioe = CategoryData();
      ioe.id = "1";
      ioe.name= "Institute of Engineering (IOE)";
      ioe.numberOfCourses = 10;
      ioe.thumbnail = "https://mero.school/uploads/thumbnails/category_thumbnails/79a65ad1d39517911c163865df34dc79.jpg";


      datas.add(ioe);
      CategoryData iom = CategoryData();
      iom.id = "2";
      iom.name= "Institute of Medicine (IOM)";
      iom.numberOfCourses = 10;
      iom.thumbnail = "https://mero.school/uploads/thumbnails/category_thumbnails/55b83e40376071d2fddf61b4e60221a7.jpg";


      datas.add(iom);


      CategoryData iost = CategoryData();
      iost.id = "3";
      iost.name= "Institute of Science and Technology (IOST)";
      iost.numberOfCourses = 10;
      iost.thumbnail = "https://mero.school/uploads/thumbnails/category_thumbnails/69b756a9b2b0cb988b04dc2f57246a3b.jpg";


      datas.add(iost);

      response.data = datas;


      dataCategoryModelSink.add(Response.completed(response));

      List<String> imgList = [
        'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
        'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
        'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
      ];
      dataCarousleSink.add(imgList);
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
