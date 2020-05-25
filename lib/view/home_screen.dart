import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/view/add_blog_screen.dart';

class Blogs {
  String image, description, likes, date, time;
  Blogs(this.image, this.description, this.date, this.likes, this.time);
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Home',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut(),
              );
            },
          )
        ],
      ),
      //  body: List<Blogs> blogsList=[],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new AddBlogScreen();
          }));
        },
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
