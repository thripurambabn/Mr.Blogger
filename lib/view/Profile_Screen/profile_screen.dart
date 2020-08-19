import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/Internetconnectivity.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/Blog_Detail/blog_detail_Screen.dart';
import 'package:mr_blogger/view/Edit_Profile/edit_profile.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/blogs_ui.dart';
import 'package:mr_blogger/view/Profile_Screen/widgets/profile_ui.dart';
import 'package:mr_blogger/view/book_marked_blogs/book_marked_blogs.dart';
import 'package:mr_blogger/view/followers_following_screen/followers_following_screem.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key key, this.uid}) : super(key: key);

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  //initialiser for tab controller
  TabController tabController;
  String email;
  String name;
  //String uid;
  String imageUrl;
  List<Blogs> blogsList = [];
  @override
  void initState() {
    //calls loaded profile details event
    BlocProvider.of<ProfileBloc>(context).add(
      LoadedProfileDeatils(widget.uid),
    );
    super.initState();
  }

  navigateToFollowerPage(
      List<String> following, String name, List<String> followers, String uid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new FollowPage(
        uid: uid,
        following: following,
        userName: name,
        followers: followers,
      );
    }));
  }

  void navigateToHomePage() {
    Navigator.popUntil(
      context,
      ModalRoute.withName(Navigator.defaultRouteName),
    );
  }

  navigateToBookMarkPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BookMarkedPage();
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
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Colors.purple[800],
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
              ),
            ),
            preferredSize: Size.fromHeight(40.0)),
        body: Builder(builder: (BuildContext context) {
          return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                return InternetConnectivity(
                  child: child,
                  connected: connected,
                );
              },
              child: SingleChildScrollView(
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
                          return ProfileUI(
                              uid: state.uid,
                              following: state.following,
                              followers: state.followers,
                              displayname: state.displayName,
                              email: state.email,
                              imageUrl: state.imageUrl,
                              buttonPressed: () {
                                buttonPressed(state.displayName, state.email,
                                    state.imageUrl, context);
                              },
                              navigateToBookMarkPage: () {
                                navigateToBookMarkPage();
                              },
                              navigateToFollowerPage: () {
                                navigateToFollowerPage(
                                    state.following,
                                    state.displayName,
                                    state.followers,
                                    state.uid);
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
                                    offset: Offset(3.0, 3.0),
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
                  Container(
                    child: Container(
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        bloc: BlocProvider.of<ProfileBloc>(context),
                        builder: (context, state) {
                          if (state is ProfileLoading) {
                            return Image.network(
                                'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                          } else if (state is ProfileLoaded) {
                            return state.blogs.length == 0
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No blogs added yet!☹️...\nAdd Yours Now🥳',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          shadows: [
                                            Shadow(
                                              blurRadius: 5.0,
                                              color: Colors.purple[200],
                                              offset: Offset(3.0, 3.0),
                                            ),
                                          ],
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Paficico',
                                          color: Colors.purple[700]),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: state.blogs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                          onTap: () => navigateToDetailPage(
                                              state.blogs[index], state.uid),
                                          title: BlogsUI(
                                            isFollowing:
                                                state.blogs[index].isFollowing,
                                            images: state.blogs[index].image,
                                            uid: state.blogs[index].uid,
                                            authorname:
                                                state.blogs[index].authorname,
                                            title: state.blogs[index].title,
                                            description:
                                                state.blogs[index].description,
                                            likes: state.blogs[index].likes,
                                            comments:
                                                state.blogs[index].comments,
                                            date: state.blogs[index].date,
                                            time: state.blogs[index].time,
                                            timeStamp:
                                                state.blogs[index].timeStamp,
                                          ));
                                    },
                                  );
                          } else if (state is ProfileNotLoaded) {
                            return errorUI();
                          }
                        },
                      ),
                    ),
                  )
                ]),
              )));
        }));
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
      'Error in loading blogs please try again later!',
      textAlign: TextAlign.center,
      style: TextStyle(
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.purple[200],
              offset: Offset(3.0, 3.0),
            ),
          ],
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Paficico',
          color: Colors.purple),
    ));
  }
}
