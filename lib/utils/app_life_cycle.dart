import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLifeCycle extends WidgetsBindingObserver {
  final AsyncCallback resumeCallback;
  final AsyncCallback suspendCallBack;

  AppLifeCycle({required this.resumeCallback, required this.suspendCallBack});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallback();
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        await suspendCallBack();
        break;
    }
  }
}
