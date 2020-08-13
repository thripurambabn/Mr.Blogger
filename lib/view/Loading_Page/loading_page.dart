import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:mr_blogger/Internetconnectivity.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/service/blog_service.dart';

class LoadingPage extends StatelessWidget {
  static BlogsService _blogsServcie = BlogsService();
  var _blog = BlogsBloc(blogsService: _blogsServcie);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity, Widget child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return InternetConnectivity(
              child: child,
              connected: connected,
            );
          },
          child: Center(
              child: Image(
            fit: BoxFit.cover,
            image: NetworkImage(
                'https://i.pinimg.com/originals/07/bf/6f/07bf6f0f7d5dd64829822e95e97f908d.gif'),
          )));
    });
  }
}
