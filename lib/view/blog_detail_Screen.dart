import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
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
  static ProfileService _profileService = ProfileService();
  var _blog = BlogsBloc(blogsService: _blogsServcie);
  var _profile =
      ProfileBloc(blogsService: _blogsServcie, profileService: _profileService);
//Navigate to homepage
  void navigateToHomePage() {
    Timer(Duration(seconds: 8), () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return new Homepage();
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text('Mr.Blogger',
              style: TextStyle(color: Colors.white, fontFamily: 'Paficico')),
          actions: <Widget>[
            Container(
              width: 50,
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: '1',
                      child: FlatButton(
                        onPressed: () {
                          //  navigateToProfilePage();
                        },
                        child: Text('Edit',
                            style: TextStyle(
                                color: Colors.purple[800],
                                fontFamily: 'Paficico')),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '2',
                      child: FlatButton(
                        child: Text('Delete',
                            style: TextStyle(
                                color: Colors.purple[800],
                                fontFamily: 'Paficico')),
                        onPressed: () async {
                          print('delete pressed');
                          _profile.add(DeleteBlog(widget.blogs.title));
                          navigateToHomePage();
                        },
                      ),
                    )
                  ];
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: new Text(
                  'Category',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Container(
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                widget.blogs.authorname,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.fromLTRB(12, 0, 10, 0),
                              child: new Text(
                                widget.blogs.time,
                                style: TextStyle(
                                  color: Colors.grey[500],
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
                          //     margin: const EdgeInsets.all(15.0),
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              widget.blogs.image,
                              fit: BoxFit.cover,
                              height: 280,
                              width: 350,
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : Container(
                                        color: Colors.purple[50],
                                        height: 300,
                                        width: 400,
                                      );
                              },
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(12, 0, 13, 0),
                        child: new Text(
                          widget.blogs.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
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
