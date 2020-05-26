import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/add_blog_screen.dart';
import 'package:mr_blogger/view/login_screen.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  UserService userService;
  List<Blogs> blogsList = [];
  @override
  void initState() {
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    blogsref.once().then((DataSnapshot snapshot) {
      var refkey = snapshot.value.keys;
      var data = snapshot.value;
      blogsList.clear();
      for (var key in refkey) {
        Blogs blog = new Blogs(data[key]['image'], data[key]['description'],
            data[key]['date'], data[key]['likes'], data[key]['time']);
        blogsList.add(blog);
      }
      setState(() {
        print('total number of blogs ${blogsList.length}');
      });
    });
    super.initState();
  }

  void navigateToSignUpPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginScreen(
        userService: userService,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text('Home',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // BlocListener(
              //   listener: (context, state) {
              //     if (state is LogOutSuccessState) {
              //       navigateToSignUpPage(context);
              //     }
              //   },
              // );
              print('pressed signout');
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut(),
              );
            },
          )
        ],
      ),
      body: Container(
        child: blogsList.length == 0
            ? Text('no blogs available')
            : new ListView.builder(
                itemCount: blogsList.length,
                itemBuilder: (BuildContext context, int index) {
                  print('${blogsList[index].image}');
                  return BlogsUi(
                      blogsList[index].image,
                      blogsList[index].description,
                      blogsList[index].likes,
                      blogsList[index].date,
                      blogsList[index].time);
                },
              ),
      ),
      floatingActionButton: RaisedButton(
        color: Colors.purple[800],
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new AddBlogScreen();
          }));
        },
        child: Text(
          'Upload Your Blog',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget BlogsUi(String image, String description, String likes, String date,
      String time) {
    final String _description = description;
    print('${description.length},length');
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                new Text('TITLE'),
              ],
            ),
            SizedBox(height: 10.0),
            Image.network(
              image,
              fit: BoxFit.cover,
              height: 300,
              width: 350,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Container(
                        color: Colors.purple[50],
                        height: 300,
                        width: 350,
                      );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('By:AuthorName'),
                  new Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.right,
                  ),
                ]),
            SizedBox(
              height: 10,
            ),
            Container(
              child: new Text(
                description.substring(0, 75) + '....',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Blogs {
  String image, description, likes, date, time;
  Blogs(this.image, this.description, this.date, this.likes, this.time);
}
