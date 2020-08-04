import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/other_user_profile_details_bloc/other_user_profile_details_bloc.dart';
import 'package:mr_blogger/blocs/other_user_profile_details_bloc/other_user_profile_details_event.dart';
import 'package:mr_blogger/blocs/other_user_profile_details_bloc/other_user_profile_details_state.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/Blog_Detail/blog_detail_Screen.dart';
import 'package:mr_blogger/view/Edit_Profile/edit_profile.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/blogs_ui.dart';
import 'package:mr_blogger/view/followers_following_screen/followers_following_screem.dart';
import 'package:mr_blogger/view/other_User_Profile/widgets/other_user_profile_ui.dart';

class OtherUserProfilePage extends StatefulWidget {
  final String uid;

  const OtherUserProfilePage({Key key, this.uid}) : super(key: key);

  _OtherUserProfilePageState createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage>
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
    print('widget.uid in OtherUserProfilePage ${widget.uid}');
    //calls loaded profile details event
    BlocProvider.of<OtherUserProfileDetailsBloc>(context).add(
      LoadedOtherUserProfileDeatils(widget.uid),
    );
    super.initState();
  }

  navigateToFollowerPage(
      List<String> following, String name, List<String> followers) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new FollowPage(
        following: following,
        userName: name,
        followers: followers,
      );
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
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: <Widget>[
            Container(
              child: BlocBuilder<OtherUserProfileDetailsBloc,
                  OtherUserProfileDetailsState>(
                bloc: BlocProvider.of<OtherUserProfileDetailsBloc>(context),
                builder: (context, state) {
                  if (state is OtherUserProfileDetailsLoading) {
                    return Image.network(
                        'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                  } else if (state is OtherUserProfileDetailsLoaded) {
                    return OtherUserProfileUI(
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
                        navigateToFollowerPage: () {
                          navigateToFollowerPage(state.following,
                              state.displayName, state.followers);
                        });
                  } else if (state is OtherUserProfileDetailsNotLoaded) {
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
            Container(
              child: Container(
                child: BlocBuilder<OtherUserProfileDetailsBloc,
                    OtherUserProfileDetailsState>(
                  bloc: BlocProvider.of<OtherUserProfileDetailsBloc>(context),
                  builder: (context, state) {
                    if (state is OtherUserProfileDetailsLoading) {
                      return Image.network(
                          'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                    } else if (state is OtherUserProfileDetailsLoaded) {
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
                                isFollowing: state.blogs[index].isFollowing,
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
                    } else if (state is OtherUserProfileDetailsNotLoaded) {
                      return errorUI();
                    }
                  },
                ),
              ),
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
