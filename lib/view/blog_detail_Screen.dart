import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/view/add_blog_screen.dart';
import 'package:mr_blogger/view/home_screen.dart';

class DetailPage extends StatefulWidget {
  final Blogs blogs;
  final String uid;

  DetailPage({Key key, this.blogs, this.uid}) : super(key: key);

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

  @override
  void initState() {
    if (widget.blogs == null) {
    } else {}
    super.initState();
  }

//Navigate to homepage
  void navigateToHomePage() {
    // Timer(Duration(seconds: 8), () {
    //   Navigator.push(context, MaterialPageRoute(
    //     builder: (context) {
    //       return new Homepage();
    //     },
    //   ));
    // });
    print('navigating back');
    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
  }

  void navigateToAddPage(blog) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return new AddBlogScreen(
          blog: blog,
          isEdit: true,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<CachedNetworkImage> cachednetworkImages = List<CachedNetworkImage>();
    for (var image in widget.blogs.image) {
      cachednetworkImages.add(
        CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          height: 240,
          width: MediaQuery.of(context).size.width / 1.2,
          placeholder: (context, url) => CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.purple[800]),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    }
    void popUpmenuChoice(String choice) {
      if (choice == '1') {
        navigateToAddPage(widget.blogs);
      } else if (choice == '2') {
        _profile.add(DeleteBlog(widget.blogs.title));
        navigateToHomePage();
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text('Mr.Blogger',
              style: TextStyle(color: Colors.white, fontFamily: 'Paficico')),
          actions: <Widget>[
            Container(
                width: 50,
                child: Visibility(
                  visible: widget.blogs.uid == widget.uid,
                  child: PopupMenuButton(
                    onSelected: popUpmenuChoice,
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: '1',
                          child: Text('Edit',
                              style: TextStyle(
                                  color: Colors.purple[800],
                                  fontFamily: 'Paficico')),
                          //  ),
                        ),
                        PopupMenuItem<String>(
                          value: '2',
                          child: Text('Delete',
                              style: TextStyle(
                                  color: Colors.purple[800],
                                  fontFamily: 'Paficico')),
                        )
                      ];
                    },
                  ),
                ))
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
                  widget.blogs.category ?? 'category',
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
                          padding: EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                                height: 200.0,
                                width: 350.0,
                                child: Carousel(
                                  images: cachednetworkImages,
                                  dotSize: 8.0,
                                  dotSpacing: 15.0,
                                  dotColor: Colors.purple[800],
                                  indicatorBgPadding: 5.0,
                                  autoplay: false,
                                  dotBgColor: Colors.white.withOpacity(0),
                                  borderRadius: true,
                                )),
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
