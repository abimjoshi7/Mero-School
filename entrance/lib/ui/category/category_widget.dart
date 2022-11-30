
import 'package:cached_network_image/cached_network_image.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/ui/utils/ImageError.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  CategoryData? categoryData;
  int? index;
  String? selectedId = "";
  Function onClickCategory;
  Function onSilentCategory;
  AnimationController animationController;

  CategoryWidget(
      {Key? key,
      this.categoryData,
      required this.index,
      required this.animationController,
      required this.onClickCategory,
      this.selectedId,
      required this.onSilentCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loadCategoriesCard(categoryData, index, selectedId);
  }

  Widget loadCategoriesCard(data, index, selectedId) {
    var model = data;

    var myColors = model.color;

    var isOpen = false;
    var isSelected = false;

    print("IS OPEN: ${animationController.status} $selectedId ${model.id}");

    if (animationController.status == AnimationStatus.completed) {
      isOpen = true;
      if (selectedId != model.id) {
        Color color = model.color;
        myColors = color.withOpacity(0.2);
        isSelected = true;
      }
    }

    // if (index % 3 == 0) {
    //   myColors = HexColor.fromHex(firstColor);
    // } else if ((index - 2) % 3 == 0) {
    //   myColors = HexColor.fromHex(secondColor);
    // } else {
    //   myColors = HexColor.fromHex(thirdColor);
    // }

    return GestureDetector(
      onTap: () {
        if (isOpen) {
          if (selectedId == categoryData?.id) {
            onSilentCategory(categoryData);
          } else {
            onClickCategory(categoryData);
          }
        } else {
          onClickCategory(categoryData);
        }
      },
      child: Card(
        elevation: isSelected ? 1 : 4.0,
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: myColors,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  mainAxisAlignment: isOpen
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            topLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(8.0)),
                        child: Container(
                          // child: FadeInImage.assetNetwork(
                          //     image: model.thumbnail,
                          //     imageErrorBuilder: (context, error, trace){
                          //       return ImageError();
                          //     },
                          //     placeholder: logo_placeholder,
                          //     height: 75,
                          //     fit: BoxFit.fill),

                          child: CachedNetworkImage(
                              // placeholder: (_, __) {
                              //   return Image.asset(logo_placeholder);
                              // },
                              imageUrl: model.thumbnail,
                              height: 75,
                              fit: BoxFit.fill,
                              errorWidget: (_, __, ___) {
                                return ImageError();
                              }),
                        )),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                          child: Column(
                            crossAxisAlignment: isOpen
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${model.name}",
                                textAlign:
                                    isOpen ? TextAlign.end : TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                softWrap: true,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text("${model.numberOfCourses} Courses",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
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

            !isOpen
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.white,
                    ),
                  )
                : SizedBox(),

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
