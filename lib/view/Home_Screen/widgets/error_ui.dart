import 'package:flutter/material.dart';

class ErrorUI extends StatelessWidget {
  const ErrorUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //blog tile widget
    return new Center(
        child: Text(
      'There are no blogs yet!☹️...\nAdd Yours Now🥳',
      textAlign: TextAlign.center,
      style: TextStyle(
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.purple[200],
              offset: Offset(8.0, 8.0),
            ),
          ],
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Paficico',
          color: Colors.purple),
    ));
  }
}
