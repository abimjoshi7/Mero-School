import 'package:entrance/bloc/sub_category_model_bloc.dart';
import 'package:entrance/data/category_model_response.dart';
import 'package:entrance/ui/category/subcategory/child_list.dart';
import 'package:entrance/ui/category/parent_list.dart';
import 'package:entrance/ui/entrance_course_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


const double maxSlide = 260.0;

class CategoryPack extends StatefulWidget {
  const CategoryPack({Key? key}) : super(key: key);

  @override
  _CategoryPackState createState() => _CategoryPackState();
}

class _CategoryPackState extends State<CategoryPack>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  bool isOpen = false;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10),
    );

    super.initState();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  Color selectedBg = Colors.white;

  void _onClickCategory(CategoryData categoryData) {
    _bloc.selectCategory(categoryData);

    if (animationController.status != AnimationStatus.forward) {
      animationController.forward();
    }
  }

  late SubCategoryModelBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<SubCategoryModelBloc>(context);

    var myChild = Container();

    double padding = MediaQuery.of(context).size.width - maxSlide;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        double slide = maxSlide * animationController.value;

        return Stack(
          children: [
            // Transform.translate(
            //     offset: Offset(maxSlide * (animationController.value-1),0),
            //     child:
            //
            // ),

            Padding(
              padding: EdgeInsets.only(left: padding),
              child: ChildList(
                animationController: animationController,
                onClickCategory: _onChildCategoryClick,
              ),
            ),

            GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Transform(
                child: ParentList(
                  animationController: animationController,
                  onClickCategory: _onClickCategory,
                  onSilentCategory: _onSilentCategory,
                ),
                transform: Matrix4.identity()..translate(-slide),
              ),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.all(8.0),
            //           child: Transform.scale(
            //             scale:animationController.isCompleted?1:0,
            //             child: FloatingActionButton(
            //               onPressed: toggle,
            //               child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Icon(
            //                     Icons.arrow_back_outlined,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ScaleTransition(
                      scale: animationController,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: toggle,
                          child: Icon(
                            Icons.arrow_forward_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )

            // AnimatedBuilder(animation: animationController, builder: (context, _){
            //

            //
            // },),
          ],
        );

        // return StreamBuilder<CategoryData>(
        //   stream: _bloc.selectedCategory.stream,
        //   builder: (context, snapshot) {
        //
        //
        //     String selectedId = "";
        //     if(snapshot.hasData && snapshot.data!=null){
        //       selectedId = "${snapshot.data?.id}";
        //     }
        //
        //
        //   }
        // );
      },
    );
  }

  static const double minDragStartEdge = 10;
  static const double maxDragStartEdge = maxSlide - 16;
  bool _canBeDragged = false;

  void close() => animationController.reverse();

  void open() => animationController.forward();

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed &&
        details.globalPosition.dx > minDragStartEdge;
    bool isDragCloseFromRight = animationController.isCompleted &&
        details.globalPosition.dx < minDragStartEdge;

    _canBeDragged = animationController.isCompleted;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      animationController.value -= delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }

    if (details.velocity.pixelsPerSecond.dx.abs() <= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.8) {
      close();
    } else {
      open();
    }
  }

  _onChildCategoryClick() {
    print("--goto detail page");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntranceCourseDetails()),
    );
  }

  _onSilentCategory(CategoryData categoryData) {
    close();
  }
}
