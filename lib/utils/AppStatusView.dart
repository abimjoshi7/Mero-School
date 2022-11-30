import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum APP_Status { LOADING, SUCCESS, EMPTY, FULL, FAILED }

class AppStatusView extends StatelessWidget {
  APP_Status status;

  String? message = '';

  AppStatusView({Key? key, required this.status, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var column;

    if (status == APP_Status.FULL) {
      message = "No more data";

      column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(message!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
          )
        ],
      );
    } else if (status == APP_Status.SUCCESS) {
      message = "Data Fetch Successful";

      column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text(message!, textAlign: TextAlign.center, style: TextStyle()),
          )
        ],
      );
    } else if (status == APP_Status.EMPTY) {
      message = "No data available";

      column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(message!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
          )
        ],
      );
    } else if (status == APP_Status.LOADING) {
      column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/progress_two.json', height: 100),
        ],
      );
    } else {
      column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 42,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message ?? '',
              style: TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    }

    return Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.topCenter,
        child: column);
  }
}
