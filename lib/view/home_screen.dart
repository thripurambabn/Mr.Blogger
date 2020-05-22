import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/view/add_blog_screen.dart';

class HomeScreen extends StatelessWidget {
  //final String name;

  // HomeScreen({Key key, @required this.name}) : super(key: key);

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //  Center(child: Text('Welcome $name!')),
        ],
      ),
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
