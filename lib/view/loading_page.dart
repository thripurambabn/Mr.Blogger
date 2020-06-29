import 'package:flutter/material.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/view/home_screen.dart';

class LoadingPage extends StatelessWidget {
  static BlogsService _blogsServcie = BlogsService();
  var _blog = BlogsBloc(blogsService: _blogsServcie);

  @override
  Widget build(BuildContext context) {
    void navigateToHomePage() {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return new Homepage();
        },
      ));
    }

    return Center(
        child: Image(
      fit: BoxFit.cover,
      image: NetworkImage(
          'https://i.pinimg.com/originals/07/bf/6f/07bf6f0f7d5dd64829822e95e97f908d.gif'),
    ));
  }
}
