import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/models/comment.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/view/home_screen.dart';
import 'package:mr_blogger/view/loading_page.dart';

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
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
  }

  void setComments(
      int timeStamp, String comment, List<Comment> comments, String uid) {
    _blog.add(BlogComments(
      timeStamp,
      _commentController.text,
      comments,
      uid,
    ));
  }

  deleteComments(int blogsTimeStamp, int commentTimeStamp) {
    print(
        'Comments inside deletecomments ${blogsTimeStamp},${commentTimeStamp}');
    _blog.add(DeleteComments(
      blogsTimeStamp,
      commentTimeStamp,
    ));
  }

  editComments(int blogsTimeStamp, int commentTimeStamp, String comment) {
    print(
        'Comments inside edit comments ${blogsTimeStamp},${commentTimeStamp} ${comment}');
    _blog.add(EditComments(blogsTimeStamp, commentTimeStamp, comment));
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> tempcomments = new List<Comment>();
    // print(
    //     'Comments inside build ${widget.timeStamp},${widget.comments} ${_commentController.text}');
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
          child: TextFormField(
              autocorrect: false,
              textCapitalization: TextCapitalization.sentences,
              controller: _commentController,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Text is empty';
                }
                return null;
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(FontAwesomeIcons.paperPlane,
                      color: Colors.purple[800]),
                  onPressed: () => {
                    tempcomments = widget.comments,
                    setState(() {
                      widget.comments.add(Comment(
                          comment: _commentController.text,
                          date: widget.timeStamp,
                          username: widget.uid));
                      commentsList();
                    }),
                    tempcomments.removeLast(),
                    setComments(widget.timeStamp, _commentController.text,
                        tempcomments, widget.uid),
                    _commentController.clear(),
                    tempcomments = new List<Comment>()
                  },
                ),
                icon: Icon(
                  FontAwesomeIcons.comment,
                  color: Colors.purple[800],
                ),
                labelText: 'write your comment',
              )),
        ),
      ]),
    );
  }

  void navigateToLoadingPage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return new Homepage();
      },
    ));
  }

  Widget commentsList() {
    List<Comment> tempcomments = new List<Comment>();
    return Expanded(
      child: ListView.builder(
        key: Key(widget.uid),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemCount: widget.comments.length,
        itemBuilder: (BuildContext context, int index) {
          print('${widget.comments[index]}');
          String readTimestamp(int commentTimeStamp) {
            var now = DateTime.now();
            var format = DateFormat('HH:mm a');
            var date = DateTime.fromMillisecondsSinceEpoch(commentTimeStamp);
            var diff = now.difference(date);
            var time = '';

            if (diff.inSeconds <= 0 ||
                diff.inSeconds > 0 && diff.inMinutes == 0 ||
                diff.inMinutes > 0 && diff.inHours == 0 ||
                diff.inHours > 0 && diff.inDays == 0) {
              time = format.format(date);
            } else if (diff.inDays > 0 && diff.inDays < 7) {
              if (diff.inDays == 1) {
                time = diff.inDays.toString() + ' day ago';
              } else {
                time = diff.inDays.toString() + ' days ago';
              }
            } else {
              if (diff.inDays == 7) {
                time = (diff.inDays / 7).floor().toString() + ' week ago';
              } else {
                time = (diff.inDays / 7).floor().toString() + ' weeks ago';
              }
            }
            return time;
          }

          return ListTile(
              title: new Text(
                  '${widget.comments[index].username}: ${widget.comments[index].comment}'),
              subtitle: Text(
                '${readTimestamp(widget.comments[index].date)}',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        deleteComments(
                            widget.timeStamp, widget.comments[index].date);
                        print('delete icon pressed');
                        tempcomments = widget.comments;
                        setState(() {
                          widget.comments.remove(widget.comments[index]);
                          commentsList();
                        });
                        tempcomments = new List<Comment>();
                      }),
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        tempcomments = widget.comments;
                        setState(() {
                          widget.comments.add(Comment(
                              comment: _commentController.text,
                              date: widget.timeStamp,
                              username: widget.uid));
                          commentsList();
                        });
                        tempcomments.removeLast();
                        print('edit icon pressed');
                        editComments(
                            widget.timeStamp,
                            widget.comments[index].date,
                            widget.comments[index].comment);
                        tempcomments = new List<Comment>();
                      })
                ],
              ));
        },
      ),
    );
  }
}
