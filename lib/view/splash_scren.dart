import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        //child:
        child: Image(
      image: NetworkImage(
          'https://www.zestcarrental.com/blog/wp-content/uploads/2016/10/travel-blog-somegirl-min.jpg'),
    )
        // Text('splash screen')
        );
  }
}
