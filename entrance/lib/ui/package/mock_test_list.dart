import 'package:entrance/ui/package/mock_test_widget.dart';
import 'package:entrance/ui/package/package_model_bloc.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/bloc/response.dart';

import 'package:entrance/ui/utils/error.dart';
import 'package:entrance/ui/utils/placeholder_loading_vertical_fixed.dart';
import 'package:flutter/material.dart';

class MockTestsList extends StatefulWidget {
  MockTestsList({Key? key}) : super(key: key);

  @override
  _MockTestsListState createState() => _MockTestsListState();
}

class _MockTestsListState extends State<MockTestsList> {
  late PackageModelBloc _bloc;

  @override
  void initState() {
    _bloc = PackageModelBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
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
                        if (snapshot.data?.data?.data?[index].numberOfCourses !=
                            0) {
                          return MockTestWidget(
                              categoryData: snapshot.data?.data?.data?[index]);
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
  }
}
