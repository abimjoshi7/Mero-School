import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/quiz/response/TopicResponse.dart';
import 'package:mero_school/utils/extension_utils.dart';

class TopicWidget extends StatelessWidget {
  TopicResponse? response;

  TopicWidget({Key? key, this.response, this.stringCallback}) : super(key: key);

  Function? stringCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        stringCallback!.call(response);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    response!.name!,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: HexColor.fromHex(colorDarkRed)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "${response!.prize}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: HexColor.fromHex(darkNavyBlue)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    response!.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: HexColor.fromHex(darkNavyBlue)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
