import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/models/comment.dart';
import 'package:mr_blogger/service/blog_service.dart';

class CommentsScreen extends StatefulWidget {
  final int timeStamp;
  final List<Comment> comments;
  final String uid;
  final String title;
  CommentsScreen(this.timeStamp, this.comments, this.uid, this.title);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController _commentController = TextEditingController();
  static BlogsService _blogsServcie = BlogsService();
  var _blog = BlogsBloc(blogsService: _blogsServcie);

  @override
  void initState() {
    super.initState();
  }

  void setComments(
      int timeStamp, String comment, List<Comment> comments, String uid) {
    print(
        'Comments inside setcomments ${timeStamp},${comments} ${_commentController.text}');
    _blog.add(BlogComments(
      timeStamp,
      _commentController.text,
      comments,
      uid,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      commentsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Comments inside build ${widget.timeStamp},${widget.comments} ${_commentController.text}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
        ),
      ),
      body: Column(children: <Widget>[
        commentsList(),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            autocorrect: false,
            textCapitalization: TextCapitalization.sentences,
            controller: _commentController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(FontAwesomeIcons.paperPlane,
                    color: Colors.purple[800]),
                onPressed: () => {
                  setComments(widget.timeStamp, _commentController.text,
                      widget.comments, widget.uid)
                },
              ),
              icon: Icon(
                FontAwesomeIcons.comment,
                color: Colors.purple[800],
              ),
              labelText: 'write your comment',
            ),

            //   onSubmitted:
          ),
        ),
      ]),
    );
  }

  Widget commentsList() {
    return Expanded(
      child: ListView.builder(
        key: Key(widget.uid),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemCount: widget.comments.length,
        itemBuilder: (BuildContext context, int index) {
          print('${widget.comments[index]}');
          return ListTile(title: new Text(widget.comments[index].comment));
        },
      ),
    );
  }
}
