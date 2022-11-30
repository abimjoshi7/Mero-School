import 'package:entrance/bloc/play_bloc.dart';
import 'package:entrance/ui/utils/VerticalSpace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
// import 'package:flutter_tex/flutter_tex.dart';
// import 'package:katex_flutter/katex_flutter.dart';

class QuestionAnswerWidget extends StatefulWidget {
  int index = 0;
  PlayBloc playBloc;

  QuestionAnswerWidget({Key? key, required this.index, required this.playBloc})
      : super(key: key);

  @override
  _QuestionAnswerWidgetState createState() => _QuestionAnswerWidgetState();
}

class _QuestionAnswerWidgetState extends State<QuestionAnswerWidget> {
  var radioIndex = -1;

  @override
  void initState() {
    var prev = widget.playBloc.getUserAnswer(widget.index);

    radioIndex = prev;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var number = widget.index + 1;

    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TeXView(
              child: TeXViewDocument(r"""Find the value of  \[\int_{0}^{1} \frac{dx}{\sqrt{1+x}-\sqrt{x}} =\] """,
                  style: TeXViewStyle(padding: TeXViewPadding.all(10))),
            ),
          ),


          VSpace(),
          VSpace(),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, optionIndex) {
                var isChecked = optionIndex == radioIndex;

                return GestureDetector(
                    onTap: () {
                      widget.playBloc.addUserAnswer(widget.index, optionIndex);
                      setState(() {
                        radioIndex = optionIndex;
                      });
                    },
                    child: Card(
                      child: Container(
                        decoration: isChecked
                            ? BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.blueAccent.withOpacity(0.1),
                                  Colors.blue.withOpacity(0.1)
                                ]),
                              )
                            : BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: ListTile(
                              // leading: optionIndex ==radioIndex ? Icon(Icons.check_box, color: secondaryColor,)
                              //     : Icon(Icons.check_box_outline_blank, color: secondaryColor),
                              leading: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.3),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "A",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isChecked
                                              ? Colors.white
                                              : Colors.blueAccent),
                                    ),
                                  )),
                              title: Text(
                                " $optionIndex: First Option ",
                                style: TextStyle(
                                    color: isChecked
                                        ? Colors.black
                                        : Colors.black),
                              )),
                        ),
                      ),
                    ));
              })
        ],
      ),
    );
  }
}
