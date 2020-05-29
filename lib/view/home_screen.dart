import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/add_blog_screen.dart';
import 'package:mr_blogger/view/blog_detail_Screen.dart';
import 'package:mr_blogger/view/login_screen.dart';
import 'package:mr_blogger/view/profile_screen.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var userService = UserService();
  List<Blogs> blogsList = [];
  Future _data;
  // Future _userdata;
  @override
  void initState() {
    _data = getblogs();
    // _userdata = getUserdata();
    super.initState();
  }

  // Future getUserdata() async {

  // }

  Future getblogs() async {
    var userid = await userService.getUser();
    print('userdata in home----- ${userid}');
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    blogsref.once().then((DataSnapshot snapshot) {
      var refkey = snapshot.value.keys;
      var data = snapshot.value;
      blogsList.clear();
      for (var key in refkey) {
        Blogs blog = new Blogs(
            data[key]['image'],
            data[key]['uid'],
            data[key]['title'],
            data[key]['description'],
            data[key]['date'],
            data[key]['likes'],
            data[key]['time']);
        blogsList.add(blog);
      }
      setState(() {
        print('total number of blogs ${blogsList.length}');
      });
    });
  }

  void navigateToSignUpPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginScreen(
        userService: userService,
      );
    }));
  }

  void navigateToDetailPage(Blogs blog) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new DetailPage(
        blogs: blog,
      );
    }));
  }

  void navigateToProfilePage() {
    print('navigating to proilepage');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new ProfilePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text('Mr.Blogger',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico')),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.userCircle),
            onPressed: navigateToProfilePage,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              print('pressed signout');
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut(),
              );
            },
          ),
        ],
      ),
      body: InkWell(
        child: Container(
          // child: blogsList.length == 0
          //     ? Text('no blogs available')
          //     : new ListView.builder(
          //         itemCount: blogsList.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           print('${blogsList[index].image}');
          //           return BlogsUi(
          //               blogsList[index].image,
          //               blogsList[index].title,
          //               blogsList[index].description,
          //               blogsList[index].likes,
          //               blogsList[index].date,
          //               blogsList[index].time);
          //         },
          //       ),
          child: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Loading...'));
              } else {
                return new ListView.builder(
                    itemCount: blogsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      print('${blogsList[index].title}');
                      //   return BlogsUi(
                      //       blogsList[index].image,
                      //       blogsList[index].title,
                      //       blogsList[index].description,
                      //       blogsList[index].likes,
                      //       blogsList[index].date,
                      //       blogsList[index].time);
                      // },
                      //  print('calling detail screen');
                      return ListTile(
                        title: blogsUi(
                            blogsList[index].image,
                            blogsList[index].uid,
                            blogsList[index].title,
                            blogsList[index].description,
                            blogsList[index].likes,
                            blogsList[index].date,
                            blogsList[index].time),
                        onTap: () => navigateToDetailPage(blogsList[index]),
                      );
                    });
              }
            },
          ),
        ),
        //   onTap: () => navigateToDetailPage(snapshot.data['index']),
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
          style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
        ),
      ),
    );
  }

  Widget blogsUi(String image, String uid, String title, String description,
      String likes, String date, String time) {
    print('uid in homeUI---${uid}');
    print('${description.length},length');
    print('${title.length}-----title length');
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
                Text(
                  title.substring(0, 9) + '....',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Paficico',
                      color: Colors.purple),
                  textAlign: TextAlign.left,
                ),
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
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
  String image, uid, title, description, likes, date, time;
  Blogs(this.image, this.uid, this.title, this.description, this.date,
      this.likes, this.time);
}
