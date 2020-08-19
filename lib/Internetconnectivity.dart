import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InternetConnectivity extends StatefulWidget {
  final Widget child;
  final bool connected;

  InternetConnectivity({Key key, this.child, this.connected}) : super(key: key);

  @override
  _InternetConnectivityState createState() => _InternetConnectivityState();
}

class _InternetConnectivityState extends State<InternetConnectivity> {
  void navigateToHomePage() {
    Navigator.popUntil(
      context,
      ModalRoute.withName(Navigator.defaultRouteName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        widget.connected
            ? Container()
            : AlertDialog(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.cloud_off,
                      size: 23,
                    ),
                    Text(
                      ' No Internet connection',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                content: Text(
                    'Please check your internet connection and try again later!'),
                actions: <Widget>[
                  FlatButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.purple[800]),
                      ),
                      onPressed: () {
                        navigateToHomePage();
                      })
                ],
              )
      ],
    ));
  }
}