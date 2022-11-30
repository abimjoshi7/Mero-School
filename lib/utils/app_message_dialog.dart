import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:mero_school/presentation/constants/colors.dart';

import 'extension_utils.dart';

enum ProgressDialogType { Normal, Download }

String? _dialogMessage = "Loading...";
double _progress = 0.0, _maxProgress = 100.0;

String action = "Okay";

Widget? _customBody;

TextAlign _textAlign = TextAlign.center;
Alignment _progressWidgetAlignment = Alignment.centerLeft;

TextDirection _direction = TextDirection.ltr;

bool _isShowing = false;
late BuildContext _context, _dismissingContext;
ProgressDialogType? _progressDialogType;
bool _barrierDismissible = true, _showLogs = false;

TextStyle _progressTextStyle = TextStyle(
        color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal),
    _messageStyle = TextStyle(
        color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal);

double _dialogElevation = 8.0, _borderRadius = 8.0;
Color _backgroundColor = Colors.white;
Curve _insetAnimCurve = Curves.easeInOut;
EdgeInsets _dialogPadding = const EdgeInsets.all(8.0);

Widget _progressWidget = Lottie.asset('assets/progress_two.json');

class AppMessageDialog {
  _Body? _dialog;

  Function? _callback;

  AppMessageDialog(BuildContext context,
      {ProgressDialogType? type,
      bool? isDismissible,
      bool? showLogs,
      TextDirection? textDirection,
      Widget? customBody,
      Function? callback,
      String? action}) {
    _context = context;
    _progressDialogType = type ?? ProgressDialogType.Download;
    _barrierDismissible = isDismissible ?? true;
    _showLogs = showLogs ?? false;
    _customBody = customBody ?? null;
    _direction = textDirection ?? TextDirection.ltr;
    _callback = callback;
  }

  void style(
      {Widget? child,
      double? progress,
      double? maxProgress,
      String? message,
      Widget? progressWidget,
      Color? backgroundColor,
      TextStyle? progressTextStyle,
      TextStyle? messageTextStyle,
      double? elevation,
      TextAlign? textAlign,
      double? borderRadius,
      Curve? insetAnimCurve,
      EdgeInsets? padding,
      Alignment? progressWidgetAlignment}) {
    if (_isShowing) return;
    if (_progressDialogType == ProgressDialogType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _backgroundColor = backgroundColor ?? _backgroundColor;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;
    _dialogElevation = elevation ?? _dialogElevation;
    _borderRadius = borderRadius ?? _borderRadius;
    _insetAnimCurve = insetAnimCurve ?? _insetAnimCurve;
    _textAlign = textAlign ?? _textAlign;
    _progressWidget = child ?? _progressWidget;
    _dialogPadding = padding ?? _dialogPadding;
    _progressWidgetAlignment =
        progressWidgetAlignment ?? _progressWidgetAlignment;
  }

  // void update(
  //     {double progress,
  //       double maxProgress,
  //       String message,
  //       Widget progressWidget,
  //       TextStyle progressTextStyle,
  //       TextStyle messageTextStyle}) {
  //   if (_progressDialogType == ProgressDialogType.Download) {
  //     _progress = progress ?? _progress;
  //   }
  //
  //   _dialogMessage = message ?? _dialogMessage;
  //   _maxProgress = maxProgress ?? _maxProgress;
  //   _progressWidget = progressWidget ?? _progressWidget;
  //   _messageStyle = messageTextStyle ?? _messageStyle;
  //   _progressTextStyle = progressTextStyle ?? _progressTextStyle;
  //
  //   if (_isShowing) _dialog.update();
  // }

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop();
        if (_showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        if (_showLogs) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }

  Future<bool> show(String? msg, String? id, String action) async {
    _dialogMessage = msg;

    try {
      if (!_isShowing) {
        _dialog = new _Body(_callback, id, action);
        showDialog<dynamic>(
          context: _context,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            _dismissingContext = context;
            return WillPopScope(
              onWillPop: () async => _barrierDismissible,
              child: Dialog(
                  backgroundColor: _backgroundColor,
                  insetAnimationCurve: _insetAnimCurve,
                  insetAnimationDuration: Duration(milliseconds: 100),
                  elevation: _dialogElevation,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(_borderRadius))),
                  child: _dialog),
            );
          },
        );
        // Delaying the function for 200 milliseconds
        // [Default transitionDuration of DialogRoute]
        await Future.delayed(Duration(milliseconds: 200));
        if (_showLogs) debugPrint('ProgressDialog shown');
        _isShowing = true;
        return true;
      } else {
        if (_showLogs) debugPrint("ProgressDialog already shown/showing");
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());

      return false;
    }
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _BodyState _dialog = _BodyState();

  Function? _callback;
  String? _id;

  String? _action;

  _Body(Function? callback, String? ids, String action) {
    _callback = callback;
    _id = ids;
    _action = action;
  }

  update() {
    _dialog.update();
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  update() {
    setState(() {});
  }

  @override
  void dispose() {
    _isShowing = false;
    if (_showLogs) debugPrint('ProgressDialog dismissed by back button');
    super.dispose();
  }

  @override
  Widget build(BuildContext cxt) {
    return _customBody ??
        Container(
          padding: _dialogPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Mero School",
                  textAlign: _textAlign,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textDirection: _direction,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _dialogMessage!,
                  textAlign: TextAlign.center,
                  style: _messageStyle,
                  textDirection: _direction,
                ),
              ),
              new TextButton(
                child: new Text(
                  "${widget._action}",
                  style: TextStyle(color: HexColor.fromHex(colorAccent)),
                ),
                onPressed: () {
                  // widget._callback();
                  try {
                    if (widget._id != null) {
                      widget._callback!(widget._id);
                    }
                  } catch (e) {
                    print(e);
                  }

                  Navigator.of(cxt).pop();
                },
              ),
            ],
          ),
        );
  }
}
