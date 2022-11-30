import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/quiz/response/ResultRp.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/utils/toast_helper.dart';

import 'congrats_alert_dialog.dart';

class WinnersWidget extends StatelessWidget {
  Winner? response;

  WinnersWidget({Key? key, this.response, this.stringCallback})
      : super(key: key);

  Function? stringCallback;

  Future<String?> getToken() async {
    return await Preference.getString(user_id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          var loggedInUser = Common.checkNullOrNot(snapshot.data);
          var displayWinner = false;

          if (response!.userId.toString() == loggedInUser) {
            displayWinner = true;
          }

          return InkWell(
            onTap: () {
              // stringCallback.call(response);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            response!.fullName!.toUpperCase(),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: HexColor.fromHex(colorDarkRed)),
                          ),
                        ),
                        Visibility(
                          visible: displayWinner,
                          child: InkWell(
                            onTap: () {
                              CongratsDialog confirmationDialog =
                                  CongratsDialog(
                                      "Congratulations !!",
                                      (response!.message != null &&
                                              response!.message!.isNotEmpty)
                                          ? "${response!.message}"
                                          : "You have won the price");

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return confirmationDialog;
                                },
                              );
                            },
                            child: Image.asset(
                              ic_trophy,
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "${response!.topic}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: HexColor.fromHex(darkNavyBlue)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (response!.yourAnswers != null &&
                                response!.yourAnswers!.length > 0) {
                              Navigator.pushNamed(context, quiz_answer_page,
                                  arguments: <String, dynamic>{
                                    "winners": response,
                                  });
                            } else {
                              ToastHelper.showShort(
                                  "You have not submitted answer!");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Show Answers",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                  color: HexColor.fromHex(darkNavyBlue)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
