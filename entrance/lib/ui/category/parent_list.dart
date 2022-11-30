import 'package:carousel_slider/carousel_slider.dart';
import 'package:entrance/bloc/category_model_bloc.dart';
import 'package:entrance/bloc/sub_category_model_bloc.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/bloc/response.dart';
import 'package:entrance/ui/category/category_widget.dart';
import 'package:entrance/ui/utils/error.dart';
import 'package:entrance/ui/utils/placeholder_loading_vertical_fixed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentList extends StatefulWidget {
  AnimationController? animationController;
  Function? onClickCategory;
  Function? onSilentCategory;

  ParentList(
      {Key? key,
      this.animationController,
      this.onClickCategory,
      this.onSilentCategory})
      : super(key: key);

  @override
  _ParentListState createState() => _ParentListState();
}

class _ParentListState extends State<ParentList> {
  late CategoryModelBloc _bloc;
  late SubCategoryModelBloc _childBloc;

  @override
  void initState() {
    _bloc = CategoryModelBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _childBloc = Provider.of<SubCategoryModelBloc>(context);

    return StreamBuilder<CategoryData>(
        stream: _childBloc.selectedCategory.stream,
        builder: (context, snapshot) {
          String selectedId = "";
          if (snapshot.hasData && snapshot.data != null) {
            selectedId = "${snapshot.data?.id}";
          }

          return Container(
            color: Colors.white,
            child: StreamBuilder<Response<CategoryModelResponse>>(
                stream: _bloc.dataCategoryModelStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        return PlaceHolderLoadingVerticalFixed();
                      case Status.COMPLETED:
                        var length = snapshot.data?.data?.data?.length ?? 0;

                        length++;

                        print("indexlength $length");

                        return ListView.builder(
                            itemCount: length,
                            itemBuilder: (BuildContext context, int index) {
                              print("index $index");
                              if (index == 0) {
                                return StreamBuilder<List<String>>(
                                    stream: _bloc.dataCarousleStream,
                                    builder: (context, data) {
                                      if (data.hasData) {
                                        return Container(
                                          color: Colors.white,
                                          child: CarouselSlider(
                                              items: data.data
                                                  ?.map((e) => Card(
                                                      child: Image.network(e,
                                                          fit: BoxFit.cover,
                                                          width: 1000)))
                                                  .toList(),
                                              options: CarouselOptions(
                                                autoPlay: true,
                                                enlargeCenterPage: true,
                                                enlargeStrategy:
                                                    CenterPageEnlargeStrategy
                                                        .height,
                                              )),
                                        );
                                      }

                                      return Container();
                                    });
                              } else {
                                index--;
                              }
                              print("index changded $index");

                              if (snapshot.data?.data?.data?[index]
                                      .numberOfCourses !=
                                  0) {
                                return CategoryWidget(
                                  categoryData:
                                      snapshot.data?.data?.data?[index],
                                  index: index,
                                  animationController:
                                      widget.animationController!,
                                  onClickCategory: widget.onClickCategory!,
                                  selectedId: selectedId,
                                  onSilentCategory: widget.onSilentCategory!,
                                );
                              }
                              return Container();
                            });
                        break;
                      case Status.ERROR:
                        return ErrorRetry(
                          errorMessage: snapshot.data?.message,
                          onRetryPressed: () => _bloc.fetchCategoryModelData(),
                          isDisplayButton: true,
                        );
                        break;
                    }
                  }
                  return Container();
                }),
          );
        });
  }
}
