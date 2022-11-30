import 'dart:math';

import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/ui/entrance_play_page.dart';
import 'package:entrance/ui/utils/confirmation_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class MockTestWidget extends StatelessWidget {
  CategoryData? categoryData;
  MockTestWidget({
    Key? key,
    this.categoryData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loadCategoriesCard(categoryData, context);
  }

  Widget loadCategoriesCard(data, context) {
    var model = data;

    var myColors = model.color;

    print("--mycolor $myColors ${model.name}");

    // if (index % 3 == 0) {
    //   myColors = HexColor.fromHex(firstColor);
    // } else if ((index - 2) % 3 == 0) {
    //   myColors = HexColor.fromHex(secondColor);
    // } else {
    //   myColors = HexColor.fromHex(thirdColor);
    // }

    var rand = Random().nextInt(10);
    bool isEnrolled = rand % 2 == 0;

    return GestureDetector(
      onTap: () {
        print("clicked");
        showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0))),
                child: ConfirmationDialog(
                    title: "Are your sure continue to start mock test ?",
                    message:
                        "You have 5 Test Left for this plan. The Duration of the test is 30 minutes You have 5 Test Left for this plan. The Duration of the test is 30 minutes",
                    action: "Continue",
                    onConfirm: () {
                      print("from preve");

                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return EntrancePlayPage();
                      }));
                      //EntrancePlayPage
                    }),
              );
            });
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            topLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(8.0)),
                        child: Container(
                          height: 95,
                          width: 105,
                          color: myColors,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "IOE",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "2021",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // child: FadeInImage.assetNetwork(
                          //     image: model.thumbnail,
                          //     imageErrorBuilder: (context, error, trace){
                          //       return ImageError();
                          //     },
                          //     placeholder: logo_placeholder,
                          //     height: 75,
                          //     fit: BoxFit.fill),
                        )),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${model.name}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                softWrap: true,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text("• 0% Negaitive Marking\n• 100 Questions",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300)),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          "START",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  Text(
                    "${rand * 5} minutes ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),

            // RotationTransition(
            //   turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Icon(
            //       Icons.arrow_forward_ios_sharp,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  //Transform(child: ParentList(animationController: animationController, onClickCategory:_onClickCategory, selectedId:  selectedId,),
//                 transform: Matrix4.identity()
//                   ..translate(-slide),
//               ),

  void _onDragEnd(DragEndDetails details) {
    print("onDragEnd--> ready to open");
  }
}
