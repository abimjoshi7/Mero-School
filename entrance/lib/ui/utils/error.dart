import 'package:flutter/material.dart';

class ErrorRetry extends StatelessWidget {
  String? errorMessage;

  Function onRetryPressed;

  bool isDisplayButton = true;

  ErrorRetry(
      {Key? key,
      this.errorMessage,
      required this.onRetryPressed,
      required this.isDisplayButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "$errorMessage",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Visibility(
              visible: isDisplayButton == null ? true : isDisplayButton,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    onRetryPressed();
                  },
                  child: Text('Retry', style: TextStyle(color: Colors.white))))
        ],
      ),
    );
  }
}
