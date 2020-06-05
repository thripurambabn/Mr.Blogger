import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/login_bloc/login_bloc.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/blog_detail_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Users user;

  const ProfilePage({Key key, this.user}) : super(key: key);

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // List<Users> userlist = [];

  var userService = UserService();
  static BlogsService _blogsService = BlogsService();
  static ProfileService _profileService = ProfileService();
  static UserService _userService = UserService();
  SharedPreferences sharedPreferences;
  String email;
  var _profile =
      ProfileBloc(profileService: _profileService, blogsService: _blogsService);
  var _login = LoginBloc(userService: _userService);
  Future _userdata;
  Future _data;
  List<Blogs> blogsList = [];
  @override
  void initState() {
    print('in profile initial state');

    _profile.add(
      LoadedProfileDeatils(),
    );

    super.initState();
  }

  void navigateToDetailPage(Blogs blog) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new DetailPage(
        blogs: blog,
      );
    }));
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
            Container(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                bloc: _profile,
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Image.network(
                        'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                  } else if (state is ProfileLoaded) {
                    return profileUi(state.displayName, state.email);
                  } else if (state is ProfileNotLoaded) {
                    return Text('Not loaded');
                  }
                },
              ),
            ),
            // profileUi(widget.user.displayName, widget.user.email),
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
              child: BlocBuilder<ProfileBloc, ProfileState>(
                bloc: _profile,
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Image.network(
                        'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                  } else if (state is ProfileLoaded) {
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.blogs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () =>
                                navigateToDetailPage(state.blogs[index]),
                            title: blogsUi(
                                state.blogs[index].image,
                                state.blogs[index].uid,
                                state.blogs[index].authorname,
                                state.blogs[index].title,
                                state.blogs[index].description,
                                state.blogs[index].likes,
                                state.blogs[index].date,
                                state.blogs[index].time));
                      },
                    );
                  } else if (state is ProfileNotLoaded) {
                    return Text('Not loaded');
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
  print('user shivraj ${username}');
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
