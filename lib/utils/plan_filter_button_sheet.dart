import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:mero_school/business_login/blocs/splash_bloc.dart';
import 'package:mero_school/data/models/response/plan_category_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';

class PlanFliterMethod extends StatefulWidget {
  Function(CategoryData? planCategory, CategoryData? packageCategory) callback;
  PlanCategoryResponse? systemSettingsResponse;

  // BuildContext popContext;
  // payment_method(this.popContext, this.callback);

  PlanFliterMethod(
      {Key? key, required this.callback, this.systemSettingsResponse})
      : super(key: key);

  @override
  _PlanFliterMethodState createState() {
    return _PlanFliterMethodState();
  }
}

class _PlanFliterMethodState extends State<PlanFliterMethod> {
  @override
  void initState() {
    _splashBloc = SplashBloc();
    _splashBloc.systemSettingsBloc();

    if (widget.systemSettingsResponse == null) {
      _splashBloc.fetchPlanCategorySettings();
    } else {
      _splashBloc.updatePlanCategorySetting(widget.systemSettingsResponse);
    }

    super.initState();
  }

  late SplashBloc _splashBloc;

  CategoryData? slectedPlan, selectedPackage;

  @override
  void dispose() {
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<Response<PlanCategoryResponse>>(
            stream: _splashBloc.planCategoryDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return loadImage();
                    break;
                  case Status.COMPLETED:
                    // _splashBloc.saveData(snapshot.data!.data!).then((value) {});

                    return mainVeiw(context, snapshot.data!.data);

                    break;
                  case Status.ERROR:
                    var showLong =
                        ToastHelper.showLong(snapshot.data!.message!);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "No Plan Category Currently Active. Please Try Again Later.",
                          textAlign: TextAlign.center),
                    );

                    // return  mainVeiw(context,null);

                    break;
                }
              }
              return loadImage();
            }));
  }

  Widget loadImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: Lottie.asset('assets/progress_two.json'),
          ),
          Text("fetching active plan categories..."),
        ],
      ),
    );
  }

  Widget mainVeiw(BuildContext context, PlanCategoryResponse? data) {
    if (data?.planCategory?.first != null) {
      var initial = data!.planCategory!.first;
      slectedPlan = initial;
      _splashBloc.selectedPlanCategoryDataSink.add(initial);
    }

    if (data?.packageCategory?.first != null) {
      var initial = data!.packageCategory!.first;
      selectedPackage = initial;
      _splashBloc.selectedPakageCategoryDataSink.add(initial);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter Plan",
                  style: TextStyle(
                      color: HexColor.fromHex(colorAccent),
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    AntDesign.closecircleo,
                    color: HexColor.fromHex(bottomNavigationEnabledState),
                  ),
                )
              ],
            ),
            Divider(
              color: HexColor.fromHex(bottomNavigationIdealState),
            ),

            //filters
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                      color: HexColor.fromHex(bottomNavigationIdealState)),
                ),
                Container(
                  width: 250,
                  child: Card(
                    child: StreamBuilder<CategoryData>(
                        stream: _splashBloc.selectedPlanCategoryDataStream,
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 3, 10),
                            child: DropdownButton<CategoryData>(
                              value: snapshot.data,
                              style: TextStyle(color: Colors.black87),
                              isExpanded: true,
                              underline: Text(''),
                              icon: Icon(
                                MaterialIcons.signal_cellular_4_bar,
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState),
                              ),
                              items: data?.planCategory
                                  ?.map<DropdownMenuItem<CategoryData>>(
                                      (CategoryData? value) {
                                return DropdownMenuItem<CategoryData>(
                                  value: value,
                                  child: Text("${value?.label}"),
                                );
                              }).toList(),
                              elevation: 16,
                              isDense: true,
                              onChanged: (newValue) async {
                                print("selected--> $newValue");

                                slectedPlan = newValue;

                                _splashBloc.selectedPlanCategoryDataSink
                                    .add(newValue!);
                              },
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Package",
                  style: TextStyle(
                      color: HexColor.fromHex(bottomNavigationIdealState)),
                ),
                Container(
                  width: 250,
                  child: Card(
                    child: StreamBuilder<CategoryData>(
                        stream: _splashBloc.selectedPackageCategoryDataStream,
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 3, 10),
                            child: DropdownButton<CategoryData>(
                              value: snapshot.data,
                              style: TextStyle(color: Colors.black87),
                              isExpanded: true,
                              underline: Text(''),
                              icon: Icon(
                                MaterialIcons.signal_cellular_4_bar,
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState),
                              ),
                              items: data?.packageCategory
                                  ?.map<DropdownMenuItem<CategoryData>>(
                                      (CategoryData? value) {
                                return DropdownMenuItem<CategoryData>(
                                  value: value,
                                  child: Text("${value?.label}"),
                                );
                              }).toList(),
                              elevation: 16,
                              isDense: true,
                              onChanged: (newValue) async {
                                print("selected--> $newValue");
                                selectedPackage = newValue;

                                _splashBloc.selectedPakageCategoryDataSink
                                    .add(newValue!);
                              },
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (data?.planCategory?.first != null) {
                        var initial = data!.planCategory!.first;
                        slectedPlan = initial;
                        _splashBloc.selectedPlanCategoryDataSink.add(initial);
                      }

                      if (data?.packageCategory?.first != null) {
                        var initial = data!.packageCategory!.first;
                        selectedPackage = initial;
                        _splashBloc.selectedPakageCategoryDataSink.add(initial);
                      }
                    },
                    child: Text("RESET"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return HexColor.fromHex(colorAccent);
                          return HexColor.fromHex(
                              colorBlue); // Use the component's default.
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      widget.callback(slectedPlan, selectedPackage);

                      Navigator.of(context).pop();
                    },
                    child: Text("APPLY"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return HexColor.fromHex(colorAccent);
                          return HexColor.fromHex(
                              colorAccent); // Use the component's default.
                        },
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
