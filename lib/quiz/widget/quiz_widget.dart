import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/quiz/response/questions.dart';
import 'package:mero_school/utils/extension_utils.dart';

class QuizQuestionModel extends StatefulWidget {
  Questions? question;

  Function? callback;

  QuizQuestionModel({Key? key, this.question, this.callback}) : super(key: key);

  @override
  _QuizQuestionModelState createState() {
    return _QuizQuestionModelState();
  }
}

class _QuizQuestionModelState extends State<QuizQuestionModel> {
  String selectedOption = "";
  String? qsnNumber = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("pressed: $qsnNumber");

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${widget.question!.questionNumber}. ${widget.question!.question}",
                style: TextStyle(
                    color: HexColor.fromHex(colorDarkRed),
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return OptionsWidget(
                  answers: widget.question!.answers![index],
                  callback: (answers) {
                    widget.callback!
                        .call(widget.question!.questionNumber, answers);

                    setState(() {
                      qsnNumber = widget.question!.questionNumber;
                      selectedOption = answers;
                    });
                  },
                  selected: qsnNumber == widget.question!.questionNumber
                      ? selectedOption
                      : "",
                );
              },
              itemCount: widget.question!.answers!.length,
            )
          ],
        ),
      ),
    );
  }
}

class OptionsWidget extends StatelessWidget {
  Answers? answers;
  String? selected;

  Function? callback;

  OptionsWidget({Key? key, this.answers, this.callback, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          callback!.call(answers!.label);
        },
        child: Container(
          decoration: BoxDecoration(
              color: answers!.label == selected
                  ? HexColor.fromHex("#3B800A00")
                  : Colors.white,
              border:
                  Border.all(color: HexColor.fromHex("#8E800A00"), width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${answers!.answer}",
                style: TextStyle(
                    color: HexColor.fromHex(darkNavyBlue),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuizProgress extends StatelessWidget {
  int? index;
  int? total;

  Function? next;
  Function? submit;

  QuizProgress({Key? key, this.index, this.total, this.next, this.submit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return index == -1
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    value: index!.toDouble() / total!.toDouble(),
                    color: HexColor.fromHex("#de5246"),
                    backgroundColor: HexColor.fromHex("#3B800A00"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${index! <= total! ? index : total}/$total",
                  style: TextStyle(
                      color: HexColor.fromHex(darkNavyBlue),
                      fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        HexColor.fromHex("#de5246")),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(16, 8, 16, 8)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)),
                    ))),
                onPressed: () {
                  index! < total! ? next!.call() : submit!.call();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(index! < total! ? "NEXT" : "SUBMIT"),
                ),
              ),
            ],
          );
  }
}

class QuizEmpty extends StatelessWidget {
  String? message = "";
  bool? loading;

  QuizEmpty({Key? key, this.message, this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var total = MediaQuery.of(context).size.width;
    var _sixty = total - 0.4 * total;

    return Column(
      children: [
        loading!
            ? SizedBox(
                height: _sixty,
                child: Lottie.asset('assets/paperplane.json', animate: true),
              )
            : Image.asset(quiz_bg_one, width: _sixty),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "$message",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
