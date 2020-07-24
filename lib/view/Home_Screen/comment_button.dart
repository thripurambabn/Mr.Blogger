import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_blogger/models/comment.dart';

class CommentButton extends StatelessWidget {
  final int timeStamp;
  final List<Comment> comments;
  final String uid;
  final String title;
  final Function navigateToCommentPage;
  const CommentButton(
      {Key key,
      this.timeStamp,
      this.comments,
      this.uid,
      this.title,
      this.navigateToCommentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('details in comment button $title');
    return new GestureDetector(
      child: new Container(
        alignment: Alignment.center,
        height: 30.0,
        width: 30.0,
        child: IconButton(
          onPressed: navigateToCommentPage,
          icon: Icon(
            FontAwesomeIcons.comment,
            color: Colors.purple[500],
            size: 15.0,
          ),
        ),
      ),
    );
  }
}
