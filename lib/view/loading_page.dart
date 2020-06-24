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
      image: NetworkImage(
          'https://cdn.dribbble.com/users/2016587/screenshots/4962637/squares-animation.gif'),
    ));
  }
}
