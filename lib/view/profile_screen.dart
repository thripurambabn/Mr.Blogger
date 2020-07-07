import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/blog_detail_Screen.dart';
import 'package:mr_blogger/view/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final Users user;

  const ProfilePage({Key key, this.user}) : super(key: key);

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  //initialiser for tab controller
  TabController tabController;
  //instance of userService
  var userService = UserService();
  static BlogsService _blogsService = BlogsService();
  static ProfileService _profileService = ProfileService();
  SharedPreferences sharedPreferences;
  String email;
  String name;
  var _profile =
      ProfileBloc(profileService: _profileService, blogsService: _blogsService);
  List<Blogs> blogsList = [];
  @override
  void initState() {
    //calls loaded profile details event
    _profile.add(
      LoadedProfileDeatils(),
    );

    super.initState();
  }

//navigates to detail page
  void navigateToDetailPage(Blogs blog, String uid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new DetailPage(
        blogs: blog,
        uid: uid,
      );
    }));
  }

  void navigateToEditProfilePage() {
    print('navigating to edit page');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new EditProfilePage(
        name: name,
        email: email,
      );
    }));
  }

  Widget build(BuildContext ctx) {
    tabController = new TabController(length: 2, vsync: this);
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(FontAwesomeIcons.userEdit),
                onPressed: () {
                  print('sending from profile');
                  navigateToEditProfilePage();
                }),
          ],
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
                    return errorUI();
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.purple[300],
            ),
            Container(
              // color: Colors.white,
              //tab bar controller
              child: TabBar(
                controller: tabController,
                tabs: [
                  new Tab(
                    icon: new Icon(Icons.list, color: Colors.purple[600]),
                  ),
                  new Tab(
                    icon: new Icon(Icons.grid_on, color: Colors.purple[600]),
                  ),
                ],
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4.0, color: Colors.purple[600]),
                ),
              ),
            ),
            Container(
              height: 8000,
              //tab bar view controller
              child: TabBarView(controller: tabController, children: [
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
                                onTap: () => navigateToDetailPage(
                                    state.blogs[index], state.uid),
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
                        return errorUI();
                      }
                    },
                  ),
                ),
                Container(
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    bloc: _profile,
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return Image.network(
                            'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                      } else if (state is ProfileLoaded) {
                        return GridView.builder(
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 0.0,
                                  childAspectRatio: 0.75),
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: state.blogs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GridTile(
                                child: blogsGridUi(
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
                        return errorUI();
                      }
                    },
                  ),
                ),
              ]),
            )
          ]),
        )));
  }

//blog tile widget
  Widget blogsUi(
      List<String> image,
      String uid,
      String authorname,
      String title,
      String description,
      List<String> likes,
      String date,
      String time) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: new Container(
        padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
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
            // Image.network(
            //   image,
            //   fit: BoxFit.cover,
            //   height: 240,
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   loadingBuilder: (context, child, progress) {
            //     return progress == null
            //         ? child
            //         : Container(
            //             color: Colors.purple[50],
            //             height: 240,
            //             width: MediaQuery.of(context).size.width / 1.2,
            //           );
            //   },
            // ),
            Carousel(
              images: [image],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text(
                      'Author Name: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      authorname ?? '',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[850],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ]),
                  new Text(
                    time,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
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
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget blogsGridUi(
      List<String> image,
      String uid,
      String authorname,
      String title,
      String description,
      List<String> likes,
      String date,
      String time) {
    return new Card(
      elevation: 15.0,
      margin: EdgeInsets.all(8.0),
      child: new Container(
        padding: EdgeInsets.all(5.0),
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
            // Image.network(
            //   image,
            //   fit: BoxFit.cover,
            //   height: 160,
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   loadingBuilder: (context, child, progress) {
            //     return progress == null
            //         ? child
            //         : Container(
            //             color: Colors.purple[50],
            //             height: 200,
            //             width: MediaQuery.of(context).size.width / 1.2,
            //           );
            //   },
            // ),
            Carousel(
              images: [image],
            )
          ],
        ),
      ),
    );
  }
}

//user deatils widget
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
                  height: 110.0,
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
            top: 30.0,
            child: Container(
              height: 150.0,
              width: 150.0,
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
      height: 70,
    ),
    Text(
      username,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          fontFamily: 'Paficico',
          color: Colors.purple[600]),
    ),
    Text(email,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          fontFamily: 'Paficico',
          color: Colors.purple[600],
        ))
  ]);
}

Widget errorUI() {
  return new SnackBar(
      content: Text('Something went wrong try after sometime!!'));
}
