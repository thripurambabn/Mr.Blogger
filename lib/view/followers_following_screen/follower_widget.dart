import 'package:flutter/material.dart';
import 'package:mr_blogger/view/followers_following_screen/followers_tile_widget.dart';

class FollowersWidget extends StatefulWidget {
  final List<String> followers;
  final String userName;
  const FollowersWidget({Key key, this.followers, this.userName})
      : super(key: key);

  @override
  _FollowersWidgetState createState() => _FollowersWidgetState();
}

class _FollowersWidgetState extends State<FollowersWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.followers.length,
      itemBuilder: (context, i) {
        print('object1 ${widget.followers[i]} $i ${widget.followers.length}');
        return widget.followers != null
            ? FollowersTileWidget(
                follower: widget.followers[i],
              )
            : Container(child: Text('you have no followers yet'));
      },
    );
  }
}
