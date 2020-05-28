import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/view/home_screen.dart';

class DetailPage extends StatefulWidget {
  final Blogs blogs;

  DetailPage({Key key, this.blogs}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text('Mr.Blogger',
              style: TextStyle(color: Colors.white, fontFamily: 'Paficico')),
        ),
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
                          widget.blogs.title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.purple,
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
                                'AuthorName',
                                style: TextStyle(
                                  color: Colors.black87,
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
                                widget.blogs.date,
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
                        padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                        child: new Text(
                          widget.blogs.description,
                          style: TextStyle(
                            color: Colors.black54,
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
