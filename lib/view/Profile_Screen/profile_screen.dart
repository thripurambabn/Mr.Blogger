import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/view/Blog_Detail/blog_detail_Screen.dart';
import 'package:mr_blogger/view/Edit_Profile/edit_profile.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/blogs_ui.dart';
import 'package:mr_blogger/view/Profile_Screen/widgets/grid_ui.dart';
import 'package:mr_blogger/view/Profile_Screen/widgets/profile_ui.dart';
import 'package:mr_blogger/view/followers_following_screen/followers_following_screem.dart';

class ProfilePage extends StatefulWidget {
  final Users user;

  const ProfilePage({Key key, this.user}) : super(key: key);

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  //initialiser for tab controller
  TabController tabController;
  String email;
  String name;
  String imageUrl;
  List<Blogs> blogsList = [];
  @override
  void initState() {
    //calls loaded profile details event
    BlocProvider.of<ProfileBloc>(context).add(
      LoadedProfileDeatils(),
    );

    super.initState();
  }

  navigateToFollowerPage(List<String> followers) {
    print('profile_screen ${followers}');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new FollowPage(followers: followers);
    }));
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

  Widget build(BuildContext ctx) {
    tabController = new TabController(length: 2, vsync: this);
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
                bloc: BlocProvider.of<ProfileBloc>(context),
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Image.network(
                        'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                  } else if (state is ProfileLoaded) {
                    print('state.follower ${state.followers}');
                    return ProfileUI(
                        followers: state.followers,
                        displayname: state.displayName,
                        email: state.email,
                        imageUrl: state.imageUrl,
                        buttonPressed: () {
                          buttonPressed(state.displayName, state.email,
                              state.imageUrl, context);
                        },
                        navigateToFollowerPage: () {
                          navigateToFollowerPage(state.followers);
                        });
                  } else if (state is ProfileNotLoaded) {
                    return Text(
                      'Something went wrong please try again later',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.purple[200],
                              offset: Offset(8.0, 8.0),
                            ),
                          ],
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Paficico',
                          color: Colors.purple),
                    );
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
                    bloc: BlocProvider.of<ProfileBloc>(context),
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
                                title: BlogsUI(
                                  followers: state.blogs[index].followers,
                                  images: state.blogs[index].image,
                                  uid: state.blogs[index].uid,
                                  authorname: state.blogs[index].authorname,
                                  title: state.blogs[index].title,
                                  description: state.blogs[index].description,
                                  likes: state.blogs[index].likes,
                                  comments: state.blogs[index].comments,
                                  date: state.blogs[index].date,
                                  time: state.blogs[index].time,
                                  timeStamp: state.blogs[index].timeStamp,
                                ));
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
                    bloc: BlocProvider.of<ProfileBloc>(context),
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
                            if (state.blogs.length == 0) {
                              return Text('There are no blogs yet');
                            } else {
                              return GridTile(
                                  child: GridUI(
                                      blogBloc:
                                          BlocProvider.of<ProfileBloc>(context),
                                      images: state.blogs[index].image,
                                      uid: state.blogs[index].uid,
                                      authorname: state.blogs[index].authorname,
                                      title: state.blogs[index].title,
                                      description:
                                          state.blogs[index].description,
                                      likes: state.blogs[index].likes,
                                      comments: state.blogs[index].comments,
                                      date: state.blogs[index].date,
                                      time: state.blogs[index].time,
                                      timeStamp: state.blogs[index].timeStamp));
                            }
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

  buttonPressed(
      String username, String email, String imageUrl, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new EditProfilePage(
        name: username,
        email: email,
        imageUrl: imageUrl,
      );
    }));
  }

  Widget errorUI() {
    return new Center(
        child: Text(
      'There are no blogs yet!☹️...\nAdd Yours Now🥳',
      textAlign: TextAlign.center,
      style: TextStyle(
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.purple[200],
              offset: Offset(8.0, 8.0),
            ),
          ],
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Paficico',
          color: Colors.purple),
    ));
  }
}
