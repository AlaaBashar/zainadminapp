import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressCircleDialog {
  static bool _isShow = false;

  static show(
      BuildContext context,
      ) {
    showDialog(
        context: context,
        builder: (_) => getCenterCircularProgress(),
        barrierDismissible: false);
    _isShow = true;
  }

  static dismiss(BuildContext context) {
    if (_isShow) {
      Navigator.pop(context);
      _isShow = false;
    }
  }
}


Widget getCenterCircularProgress(
    {double? padding, double? size, Color? color, double radius = 12 , }) {
  return Container(
    padding: EdgeInsets.all(padding ?? 0.0),
    height: size ,
    width: size ,
    child: Center(
      child: CupertinoActivityIndicator(radius: radius,),
    ),
  );
}

void showSnackBar(BuildContext context, String value,
    {bool isError = false,
      bool isSuccess = false,
      Duration? duration,
      SnackBarAction? snackBarAction}) {
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    content: new Text(
      value,
    ),
    duration: duration ?? Duration(seconds: 2),
    action: snackBarAction,
    backgroundColor: isError
        ? Colors.red[800]
        : isSuccess
        ? Colors.green[800]
        : null,
  ));
}

double getScreenWidth(BuildContext context, {bool realWidth = false}) {
  if (realWidth) return MediaQuery.of(context).size.width;

  //to preview widget like phone scale in preview

  return MediaQuery.of(context).orientation == Orientation.portrait
      ? MediaQuery.of(context).size.width
      : MediaQuery.of(context).size.height;
}

double getScreenHeight(BuildContext context, {bool realHeight = false}) {
  if (realHeight) return MediaQuery.of(context).size.height;


  return MediaQuery.of(context).orientation == Orientation.portrait
      ? MediaQuery.of(context).size.height
      : MediaQuery.of(context).size.width;
}

String getStringFromEnum(Object value) => value.toString().split('.').last;

T? enumValueFromString<T>(String? key, List<T> values, {required T onNull}) => key != null
    ? values.firstWhere((v) => key == getStringFromEnum(v!),
    orElse: () => onNull )
    : onNull ?? null;

Future<dynamic> openNewPage(BuildContext context, Widget widget,
    {bool popPreviousPages = false}) {

  return  Future<dynamic>.delayed(Duration.zero,(){
    if (!popPreviousPages)
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => widget,
          settings: RouteSettings(arguments: widget),
        ),
      );
    else
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => widget,
              settings: RouteSettings(
                arguments: widget,
              )),
              (Route<dynamic> route) => false);
  });

}

bool isValidEmail(String email) {
  return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

