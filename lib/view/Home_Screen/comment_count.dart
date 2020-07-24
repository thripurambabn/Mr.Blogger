import 'package:flutter/material.dart';
import 'package:mr_blogger/models/comment.dart';

class CommentCount extends StatelessWidget {
  final List<Comment> comments;
  const CommentCount({
    Key key,
    this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Opacity(
        opacity: 1.0,
        child: new Container(
            height: 10,
            width: 10.0,
            child: new Center(
                child: new Text(
              comments.length.toString(),
              style: new TextStyle(color: Colors.grey[700], fontSize: 10.0),
            ))));
  }
}
