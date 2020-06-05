import 'package:flutter/material.dart';
import 'package:mr_blogger/view/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'home':
      return MaterialPageRoute(builder: (_) => Homepage());
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}
