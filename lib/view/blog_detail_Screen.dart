import 'package:flutter/material.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/view/home_screen.dart';

class DetailPage extends StatefulWidget {
  final Blogs blogs;

  DetailPage({Key key, this.blogs}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

//Blog details view
class _DetailPageState extends State<DetailPage> {
  static BlogsService _blogsServcie = BlogsService();
  var _blog = BlogsBloc(blogsService: _blogsServcie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.purple[800],
            title: Text('Mr.Blogger',
                style: TextStyle(color: Colors.white, fontFamily: 'Paficico')),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // _select(choices[0]);
                },
              ),
              // action button
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _blog.add(DeleteBlog(widget.blogs.timeStamp));
                  print('pressed delete ${widget.blogs.timeStamp}');
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return new Homepage();
                    },
                  ));
                },
              ),
            ]),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Container(
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          //widget.blogs.uid,
                          widget.blogs.title ?? '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.purple[800],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60))),
                        child: Image.network(
                          widget.blogs.image,
                          fit: BoxFit.cover,
                          height: 300,
                          width: 350,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : Container(
                                    color: Colors.purple[50],
                                    height: 300,
                                    width: 350,
                                  );
                          },
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                              child: Text(
                                widget.blogs.authorname,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.fromLTRB(12, 0, 15, 0),
                              child: new Text(
                                widget.blogs.time,
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(12, 0, 13, 0),
                        child: new Text(
                          widget.blogs.description,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ]),
                  ),
                ),
              )
              //   ],
              // )),
            ],
          ),
        ));
  }
}
