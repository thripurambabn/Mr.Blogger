import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';

class FollowButton extends StatefulWidget {
  final List<String> followers;
  final List<String> following;
  final String uid;
  final int timeStamp;

  const FollowButton({
    Key key,
    this.followers,
    this.uid,
    this.timeStamp,
    this.following,
  }) : super(key: key);
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    void setfollow(int timeStamp, List<String> followers, String uid,
        List<String> following) {
      BlocProvider.of<BlogsBloc>(context)
          .add(FollowBlogs(timeStamp, followers, following));
    }

    return new Row(children: <Widget>[
      GestureDetector(
          onTap: () => {
                setState(() {
                  if (widget.followers.contains(widget.uid)) {
                    widget.followers.remove(widget.uid);
                  } else {
                    widget.followers.add(widget.uid);
                  }
                }),
                setfollow(widget.timeStamp, widget.followers, widget.uid,
                    widget.following),
              },
          child: new Container(
              height: 23.0,
              width: 60.0,
              padding: new EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(50.0),
                color: Colors.white,
              ),
              child: widget.followers.contains(widget.uid) == true
                  ? Text(
                      'Following',
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    )
                  : Text(
                      'Follow',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ))),
    ]);
  }
}
