import 'package:flutter/material.dart';
import 'package:mr_blogger/view/followers_following_screen/follower_widget.dart';
import 'package:mr_blogger/view/followers_following_screen/following_widget.dart';

class FollowPage extends StatefulWidget {
  final List<String> followers;
  final String userName;
  FollowPage({Key key, this.followers, this.userName}) : super(key: key);

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  @override
  Widget build(BuildContext context) {
    print('followers_following_screen ${widget.userName}');
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
                  followers: widget.followers, userName: widget.userName),
              FollowingWidget(followers: widget.followers),
            ],
          ),
        ),
      ),
    );
  }
}
