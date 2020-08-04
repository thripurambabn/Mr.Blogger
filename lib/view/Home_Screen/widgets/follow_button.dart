import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';

class FollowButton extends StatefulWidget {
  bool isFollowing;
  final String uid;

  FollowButton({
    Key key,
    this.uid,
    this.isFollowing,
  }) : super(key: key);
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    void setfollow(
      bool isFollowing,
      String uid,
    ) {
      BlocProvider.of<BlogsBloc>(context).add(FollowBlogs(isFollowing, uid));
    }

    return new Row(children: <Widget>[
      GestureDetector(
          onTap: () => {
                setState(() {
                  if (widget.isFollowing) {
                    widget.isFollowing = false;
                  } else {
                    widget.isFollowing = true;
                  }
                }),
                setfollow(
                  widget.isFollowing,
                  widget.uid,
                ),
              },
          child: new Container(
              height: 23.0,
              width: 60.0,
              padding: new EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(50.0),
                color: Colors.white,
              ),
              child: widget.isFollowing == true
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
