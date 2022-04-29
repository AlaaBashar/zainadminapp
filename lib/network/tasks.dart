import 'package:flutter/material.dart';

import '../utils.dart';

class Task {
  bool isSuccess = false;
  bool isTimeOut = false;
  String msgError = "Unknown Error";

  void copyTask(Task task) {
    msgError = task.msgError;
    isSuccess = task.isSuccess;
  }

  void showSnackBarTimeOut({required BuildContext context, Function? onRetry}) {
    showSnackBar(context, msgError ,
        isError: true,
        duration: const Duration(minutes: 5),
        snackBarAction: SnackBarAction(
          label: 'Retry',
          textColor: Theme.of(context).accentColor,
          onPressed: () => onRetry?.call(),
        ));
  }


}