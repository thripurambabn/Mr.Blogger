import 'package:flutter/material.dart';
import 'package:mr_blogger/view/followers_following_screen/following_tile_widget.dart';

class FollowingWidget extends StatefulWidget {
  final List<String> following;
  final String userName;
  const FollowingWidget({Key key, this.following, this.userName})
      : super(key: key);

  @override
  _FollowingWidgetState createState() => _FollowingWidgetState();
}

class _FollowingWidgetState extends State<FollowingWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.following.length,
      itemBuilder: (context, i) {
        print(
            'object in following widget ${widget.following[i]} $i ${widget.following.length}');
        return widget.following != null
            ? FollowingTileWidget(
                following: widget.following[i],
              )
            : Container(child: Text('you have no followers yet'));
      },
    );
  }
}
