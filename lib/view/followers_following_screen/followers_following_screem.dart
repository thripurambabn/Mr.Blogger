import 'package:flutter/material.dart';
import 'package:mr_blogger/view/followers_following_screen/follower_widget.dart';
import 'package:mr_blogger/view/followers_following_screen/following_widget.dart';
import 'package:mr_blogger/view/other_User_Profile/other_user_profile.dart';

class FollowPage extends StatefulWidget {
  final List<String> following;
  final List<String> followers;
  final String uid;
  final String userName;
  FollowPage({Key key, this.following, this.userName, this.followers, this.uid})
      : super(key: key);

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  void navigateToProfilePage(String uid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new OtherUserProfilePage(uid: uid);
    }));
  }

  @override
  Widget build(BuildContext context) {
    print('follwoer_following screen ${widget.uid}');

    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.userName),
            backgroundColor: Colors.purple[800],
            bottom: TabBar(
              unselectedLabelColor: Colors.purple[200],
              labelColor: Colors.white,
              indicatorWeight: 2,
              indicatorColor: Colors.purple[100],
              tabs: [
                Tab(
                  text: 'Followers',
                ),
                Tab(
                  text: 'Following',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FollowersWidget(
                uid: widget.uid,
                followers: widget.followers,
                userName: widget.userName,
                navigateToProfilePage: (String value) {
                  navigateToProfilePage(value);
                },
              ),
              FollowingWidget(
                uid: widget.uid,
                following: widget.following,
                userName: widget.userName,
                navigateToProfilePage: (String value) {
                  navigateToProfilePage(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
