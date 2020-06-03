import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Users> userlist = [];
  var userService = UserService();
  static BlogsService _blogsService = BlogsService();
  static ProfileService _profileService = ProfileService();
  var _profile =
      ProfileBloc(profileService: _profileService, blogsService: _blogsService);
  Future _userdata;
  Future _data;
  List<Blogs> blogsList = [];
  @override
  void initState() {
    // _userdata = profileService.getUserdata();
    // _data = profileService.getblogs();
    // print('userdata in init state ${_userdata}');
    // super.initState();

    print('in profile initial state');

    _profile.add(
      LoadedProfileDeatils(),
    );
    super.initState();
  }

  Widget build(BuildContext ctx) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: <Widget>[
            //    profileUi(userlist[0].username, userlist[0].email),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Blogs',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    // fontFamily: 'Paficico',
                    color: Colors.purple),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(
              height: 10,
              thickness: 5,
              color: Colors.purple,
            ),
            Container(
              child: BlocBuilder<BlogsBloc, BlogsState>(
                bloc: BlogsBloc(blogsService: _blogsService),
                builder: (context, state) {
                  print(
                      '---------------------------${state}------------------');
                  if (state is BlogsLoaded) {
                    return Text('blogs are here ${state.blogs}');
                  } else if (state is BlogsNotLoaded) {
                    return Text('Not loaded');
                  } else if (state is BlogsLoading) {
                    return Text('blogs loading...');
                  }
                },
              ),
            ),
          ]),
        )));
  }

  Widget blogsUi(String image, String uid, String authorname, String title,
      String description, String likes, String date, String time) {
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
                  Text(
                    'By: ' + authorname,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.right,
                  ),
                  new Text(
                    date,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[350],
                    ),
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

Widget profileUi(String username, String email) {
  return new Column(children: <Widget>[
    Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          colors: [
                            Colors.purple[400],
                            Colors.purple[300],
                            Colors.purple[900]
                          ],
                          end: FractionalOffset.topCenter),
                      color: Colors.purpleAccent),
                ),
              )
            ],
          ),
          Positioned(
            top: 45.0,
            child: Container(
              height: 190.0,
              width: 190.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG2_068DwPxMkNGtNretnitrJOBG4hJSeYGGyI9yfSaCvRA7Rj&usqp=CAU'),
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 6.0)),
            ),
          ),
        ],
      ),
    ),
    SizedBox(
      height: 90,
    ),
    Text(
      username,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
    ),
    Text(
      email,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
    )
  ]);
}

class Users {
  String username, email;
  Users(this.username, this.email);
}
