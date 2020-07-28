import 'package:flutter/material.dart';

class FollowingWidget extends StatefulWidget {
  final List<String> followers;
  const FollowingWidget({Key key, this.followers}) : super(key: key);

  @override
  _FollowingWidgetState createState() => _FollowingWidgetState();
}

class _FollowingWidgetState extends State<FollowingWidget> {
  @override
  Widget build(BuildContext context) {
    print('following_widget ${widget.followers}');
    return ListView.builder(
      itemCount: widget.followers.length,
      itemBuilder: (context, i) {
        return widget.followers != null
            ? ListTile(
                title: Text(widget.followers[i].toString()),
              )
            : Container(child: Text('you have no followers yet'));
      },
    );
  }
}
