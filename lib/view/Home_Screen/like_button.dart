import 'package:flutter/material.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/service/blog_service.dart';

class LikeButton extends StatefulWidget {
  final List<String> likes;
  final String uid;
  final int timeStamp;
  const LikeButton({Key key, this.likes, this.uid, this.timeStamp})
      : super(key: key);
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    BlogsService _blogsServcie = BlogsService();
    var _blog = BlogsBloc(blogsService: _blogsServcie);
    void setlike(int timeStamp, List<String> likes, String uid) {
      _blog.add(BlogLikes(timeStamp, likes));
    }

    return new GestureDetector(
        onTap: () => {
              setState(() {
                if (widget.likes.contains(widget.uid)) {
                  widget.likes.remove(widget.uid);
                } else {
                  widget.likes.add(widget.uid);
                }
              }),
              setlike(widget.timeStamp, widget.likes, widget.uid),
            },
        child: new Container(
          height: 20.0,
          width: 20.0,
          padding: new EdgeInsets.all(0.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(50.0),
            color: Colors.white,
          ),
          child: widget.likes.contains(widget.uid) == true
              ? Icon(Icons.favorite, color: Colors.purple[500], size: 20)
              : Icon(Icons.favorite_border,
                  color: Colors.purple[500], size: 20.0),
        ));
  }
}
