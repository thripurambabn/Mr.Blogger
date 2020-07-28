import 'package:flutter/material.dart';

class FollowersWidget extends StatefulWidget {
  final List<String> followers;
  const FollowersWidget({Key key, this.followers}) : super(key: key);

  @override
  _FollowersWidgetState createState() => _FollowersWidgetState();
}

class _FollowersWidgetState extends State<FollowersWidget> {
  @override
  Widget build(BuildContext context) {
    print('follow_widget ${widget.followers}');
    return ListView.builder(
      itemCount: widget.followers.length,
      itemBuilder: (context, i) {
        return widget.followers != null
            ? ListTile(
                title: Text(widget.followers[i]),
              )
            : Container(child: Text('you have no followers yet'));
      },
    );
  }
}
