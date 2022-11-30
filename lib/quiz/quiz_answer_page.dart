import 'package:flutter/material.dart';


import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/widgets/loading/mydivider.dart';
import 'package:mero_school/quiz/response/ResultRp.dart';
import 'package:mero_school/quiz/widget/answer_widget.dart';
import 'package:mero_school/utils/extension_utils.dart';

class QuizAnswerPage extends StatefulWidget {
  QuizAnswerPage({Key? key}) : super(key: key);

  @override
  _QuizAnswerPageState createState() {
    return _QuizAnswerPageState();
  }
}

class _QuizAnswerPageState extends State<QuizAnswerPage> {
  Map? _arguments;
  Winner? _winners;

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
    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    _winners = _arguments!["winners"];

    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            logo_no_text,
            height: 38,
            width: 38,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: HexColor.fromHex(bottomNavigationEnabledState)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  "Quiz Answers",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: HexColor.fromHex(colorBlue)),
                ),
              ),
            ),

            // Text("YourAnswers: ${_winners.yourAnswers.length}")

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return MyDivider();
                  },
                  itemCount: _winners!.yourAnswers!.length,
                  itemBuilder: (context, index) {
                    return AnswerWidget(
                      response: _winners!.yourAnswers![index],
                      stringCallback: (topic) {
                        // selectedResponse = topic;
                        // _quizBloc.fetchQuestions(topic);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
