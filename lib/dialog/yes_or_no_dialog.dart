import 'package:flutter/material.dart';

class AlertDialogYesORNo extends StatefulWidget {
  final Function onYes;

  final String title;

  final String content;

  const AlertDialogYesORNo(
      {Key? key, required this.onYes, required this.title,
        required this.content})
      : super(key: key);

  @override
  _AlertDialogYesORNoState createState() => _AlertDialogYesORNoState();
}

class _AlertDialogYesORNoState extends State<AlertDialogYesORNo> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(
          widget.content),
      actions: [
        TextButton(
          child: Text('لا'),
          onPressed:()=> Navigator.pop(context) ,
        ),
        TextButton(
          child: Text('نعم'),
          onPressed:()=> widget.onYes(),
        )
      ],
    );
  }
}
