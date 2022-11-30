import 'package:entrance/bloc/sub_category_model_bloc.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/bloc/response.dart';
import 'package:entrance/ui/category/subcategory/sub_category_widget.dart';
import 'package:entrance/ui/utils/error.dart';
import 'package:entrance/ui/utils/placeholder_loading_vertical_fixed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChildList extends StatefulWidget {
  AnimationController? animationController;
  Function? onClickCategory;
  ChildList({Key? key, this.animationController, this.onClickCategory})
      : super(key: key);

  @override
  _ChildListState createState() => _ChildListState();
}

class _ChildListState extends State<ChildList> {
  late SubCategoryModelBloc _bloc;

  @override
  void initState() {
    // _bloc = CategoryModelBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<SubCategoryModelBloc>(context);

    return StreamBuilder<CategoryData>(
        stream: _bloc.selectedCategory.stream,
        builder: (context, snapshot) {
          String selectedId = "";
          if (snapshot.hasData && snapshot.data != null) {
            selectedId = "${snapshot.data?.id}";
          }

          return Container(
            margin: EdgeInsets.only(left: 0),
            color: Colors.white,
            child: StreamBuilder<Response<CategoryModelResponse>>(
                stream: _bloc.dataCategoryModelStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        return PlaceHolderLoadingVerticalFixed();
                        // return Text("test 3");
                        break;
                      case Status.COMPLETED:
                        return ListView.builder(
                            itemCount: snapshot.data?.data?.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (snapshot.data?.data?.data?[index]
                                      .numberOfCourses !=
                                  0) {
                                return SubCategoryWidget(
                                    categoryData:
                                        snapshot.data?.data?.data?[index],
                                    index: index,
                                    animationController:
                                        widget.animationController!,
                                    onClickCategory: widget.onClickCategory!,
                                    selectedId: selectedId);
                              }
                              return Container();
                            });
                        break;
                      case Status.ERROR:
                        return ErrorRetry(
                          errorMessage: snapshot.data?.message,
                          onRetryPressed: () =>
                              _bloc.fetchCategoryModelData(selectedId),
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
