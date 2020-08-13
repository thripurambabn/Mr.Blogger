import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mr_blogger/Internetconnectivity.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/models/comment.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/view/Home_Screen/home_screen.dart';

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
  bool isEdit = false;
  int commentIndex;
  @override
  void initState() {
    super.initState();
  }

  void setComments(
      int timeStamp, String comment, List<Comment> comments, String uid) {
    BlocProvider.of<BlogsBloc>(context).add(BlogComments(
      timeStamp,
      _commentController.text,
      comments,
      uid,
    ));
  }

  deleteComments(int blogsTimeStamp, int commentTimeStamp) {
    BlocProvider.of<BlogsBloc>(context).add(DeleteComments(
      blogsTimeStamp,
      commentTimeStamp,
    ));
  }

  editComments(int blogsTimeStamp, int commentTimeStamp, String comment) {
    BlocProvider.of<BlogsBloc>(context)
        .add(EditComments(blogsTimeStamp, commentTimeStamp, comment));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return OfflineBuilder(
            connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
              final bool connected = connectivity != ConnectivityResult.none;
              return InternetConnectivity(
                child: child,
                connected: connected,
              );
            },
            child: Column(children: <Widget>[
              commentsList(),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _commentController,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Comment cant be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(FontAwesomeIcons.paperPlane,
                              color: Colors.purple[800]),
                          onPressed: () => {
                                if (commentIndex != null)
                                  {
                                    widget.comments[commentIndex].comment =
                                        _commentController.text,
                                    (!_commentController.text.isEmpty)
                                        ? {
                                            setState(() {
                                              commentsList();
                                            }),
                                            editComments(
                                              widget.timeStamp,
                                              widget
                                                  .comments[commentIndex].date,
                                              _commentController.text,
                                            ),
                                            _commentController.clear(),
                                          }
                                        : null,
                                    commentIndex = null,
                                  }
                                else
                                  {
                                    (!_commentController.text.isEmpty)
                                        ? {
                                            setState(() {
                                              commentsList();
                                            }),
                                            setComments(
                                                widget.timeStamp,
                                                _commentController.text,
                                                widget.comments,
                                                widget.uid),
                                            _commentController.clear(),
                                          }
                                        : null
                                  }
                              }),
                      icon: Icon(
                        FontAwesomeIcons.comment,
                        color: Colors.purple[800],
                      ),
                      labelText: 'write your comment',
                    )),
              ),
            ]),
          );
        }));
  }

  void navigateToLoadingPage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return new Homepage();
      },
    ));
  }

  Widget commentsList() {
    // List<Comment> tempcomments = new List<Comment>();
    return Expanded(
      child: ListView.builder(
        key: Key(widget.uid),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemCount: widget.comments.length,
        itemBuilder: (BuildContext context, int index) {
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
                '${widget.comments[index].username}',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.comments[index].comment}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      '${readTimestamp(widget.comments[index].date)}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                    ),
                  ]),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 18,
                      ),
                      onPressed: () {
                        _commentController.text =
                            widget.comments[index].comment;
                        setState(() {
                          commentIndex = index;
                        });
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        size: 18,
                      ),
                      onPressed: () {
                        deleteComments(
                            widget.timeStamp, widget.comments[index].date);

                        //tempcomments = widget.comments;
                        setState(() {
                          widget.comments.remove(widget.comments[index]);
                          commentsList();
                        });
                        //tempcomments = new List<Comment>();
                      }),
                ],
              ));
        },
      ),
    );
  }
}
