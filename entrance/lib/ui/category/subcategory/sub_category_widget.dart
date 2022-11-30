
import 'package:cached_network_image/cached_network_image.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/ui/utils/ImageError.dart';
import 'package:flutter/material.dart';

class SubCategoryWidget extends StatelessWidget {
  CategoryData? categoryData;
  int? index;
  String? selectedId = "";
  Function onClickCategory;
  AnimationController animationController;

  SubCategoryWidget(
      {Key? key,
      this.categoryData,
      required this.index,
      required this.animationController,
      required this.onClickCategory,
      this.selectedId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loadCategoriesCard(context, categoryData, index, selectedId);
  }

  Widget loadCategoriesCard(context, data, index, selectedId) {
    var model = data;

    return GestureDetector(
      onTap: () {
        onClickCategory();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(0.0),
                        bottomLeft: Radius.circular(0.0)),
                    child: Container(
                      // child: FadeInImage.assetNetwork(image: model.thumbnail,
                      //     placeholder: logo_placeholder,
                      //     height: 140,
                      //     width: MediaQuery.of(context).size.width,
                      //     fit: BoxFit.fill,
                      //     imageErrorBuilder: (_,__,___){
                      //       return ImageError(size: 140,);
                      //     },
                      // ),

                      child: CachedNetworkImage(
                          // placeholder: (_, __) {
                          //   return Image.asset(logo_placeholder);
                          // },
                          imageUrl: model.thumbnail,
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          errorWidget: (_, __, ___) {
                            return ImageError(size: 140);
                          }),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      model.name.toUpperCase(),
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "10 Set, 200 Questions",
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Transform(child: ParentList(animationController: animationController, onClickCategory:_onClickCategory, selectedId:  selectedId,),
//                 transform: Matrix4.identity()
//                   ..translate(-slide),
//               ),

}
