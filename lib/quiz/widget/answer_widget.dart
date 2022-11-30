import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/quiz/response/ResultRp.dart';
import 'package:mero_school/utils/extension_utils.dart';

class AnswerWidget extends StatelessWidget {
  Your_answers? response;

  AnswerWidget({Key? key, this.response, this.stringCallback})
      : super(key: key);

  Function? stringCallback;

  @override
  Widget build(BuildContext context) {
    var displayYourResult = false;

    var icon = FontAwesome.check_circle;

    Widget myAns = Container();

    bool right = false;

    if (response!.yourAnswer != null) {
      if (response!.yourOption == response!.correctOption) {
        right = true;
      }
      myAns = Row(
        children: [
          Icon(
            right ? Icons.check_circle : MaterialIcons.cancel,
            color: right
                ? HexColor.fromHex("#32BEA6")
                : HexColor.fromHex("#f44336"),
            size: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Your Answer:",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: HexColor.fromHex(darkNavyBlue)),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "${response!.yourAnswer}",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: HexColor.fromHex(darkNavyBlue)),
              ),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: () {
        // stringCallback.call(response);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "${response!.questionNumber}. ${response!.question}",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: HexColor.fromHex(darkNavyBlue)),
              ),
            ),
            myAns,
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Correct Answer:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: HexColor.fromHex(darkNavyBlue)),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${response!.answer}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: HexColor.fromHex(darkNavyBlue)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
