import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/comment.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/add_blog_screen.dart';
import 'package:mr_blogger/view/blog_detail_Screen.dart';
import 'package:mr_blogger/view/comment_screen.dart';
import 'package:mr_blogger/view/initial_screen.dart';
import 'package:mr_blogger/view/login_screen.dart';
import 'package:mr_blogger/view/profile_screen.dart';
import 'package:mr_blogger/view/search_blog.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //instance of user Service
  var userService = UserService();
  static BlogsService _blogsServcie = BlogsService();
  List<Blogs> blogsList = [];
  Blogs blogs;
  final _scrollController = ScrollController();
  var _blog = BlogsBloc(blogsService: _blogsServcie);
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    //listener for scroll event
    _scrollController.addListener(_onScroll);
    //inital call for get blogs
    getBlogs();
  }

//events on scroll for pagiantion
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    //get more blogs on scroll
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _blog.add(FetchBlogs());
    }
  }

//calls Fetch Blogs event
  void getBlogs() async {
    await _blog.add(FetchBlogs());
  }

// //navigate to sign Up page
//   void navigateToSignUpPage(BuildContext context) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       return LoginForm(
//         userService: userService,
//       );
//     }));
//   }

//navigate to sign Up page
  void navigateTocommentPage(
      int timeStamp, List<Comment> comments, String uid, String title) {
    print('sending ${timeStamp},${comments}');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CommentsScreen(timeStamp, comments, uid, title);
    }));
  }

//navigate to detail page page
  void navigateToDetailPage(Blogs blog, String uid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new DetailPage(
        blogs: blog,
        uid: uid,
      );
    }));
  }

//navigate to profile page
  void navigateToProfilePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new ProfilePage();
    }));
  }

//navigate to profile page
  void navigateToSerachPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new SearchPage();
    }));
  }

  void navigateToinitialScreen() {
    Navigator.pop(context, MaterialPageRoute(builder: (context) {
      return InitialScreen(
        userService: userService,
      );
    }));
  }

  void setlike(int timeStamp, List<String> likes, String uid) {
    print('like in UI setLike${timeStamp},${likes}');
    _blog.add(BlogLikes(timeStamp, likes));
  }

//loading indicator while fetching more blogs
  Widget bottomLoader() {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text('Mr.Blogger',
      style: TextStyle(color: Colors.white, fontFamily: 'Paficico'));
  final TextEditingController searchBlog = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.purple[800],
          title: cusSearchBar,
          actions: <Widget>[
            IconButton(
              icon: cusIcon,
              onPressed: navigateToSerachPage,
            ),
            Container(
              width: 50,
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: '1',
                      child: FlatButton(
                        onPressed: () {
                          navigateToProfilePage();
                        },
                        child: Text('Profile',
                            style: TextStyle(
                                color: Colors.purple[800],
                                fontFamily: 'Paficico')),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '2',
                      child: FlatButton(
                        child: Text('Logout',
                            style: TextStyle(
                                color: Colors.purple[800],
                                fontFamily: 'Paficico')),
                        onPressed: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            AuthenticationLoggedOut(),
                          );
                          //navigateToinitialScreen();
                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(
                          //         builder: (context) => LoginForm(
                          //               userService: userService,
                          //             )),
                          //     (Route<dynamic> route) => false);
                        },
                      ),
                    )
                  ];
                },
              ),
            )
          ],
        ),
        //handles blog list view on state change
        body: Container(
          child: BlocBuilder<BlogsBloc, BlogsState>(
            bloc: _blog,
            builder: (context, state) {
              //Loading state
              if (state is BlogsLoading) {
                return Image.network(
                  'https://www.goodtoseo.com/wp-content/uploads/2017/09/blog_sites.gif',
                  alignment: Alignment.center,
                );
              } //Loaded state
              else if (state is BlogsLoaded) {
                return ListView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: state.hasReachedMax
                      ? state.blogs.length
                      : state.blogs.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    //print('state of blogs ${state.blogs[index].likes}');
                    return index >= state.blogs.length
                        ? bottomLoader()
                        : ListTile(
                            onTap: () => navigateToDetailPage(
                                state.blogs[index], state.uid),
                            title: blogsUi(
                              state.blogs[index].image,
                              state.blogs[index].uid,
                              state.blogs[index].authorname,
                              state.blogs[index].title,
                              state.blogs[index].description,
                              state.blogs[index].likes,
                              state.blogs[index].comments,
                              state.blogs[index].date,
                              state.blogs[index].time,
                              state.blogs[index].timeStamp,
                            ));
                  },
                  controller: _scrollController,
                ); //error state
              } else if (state is BlogsNotLoaded) {
                return errorUI();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple[800],
          onPressed: () {
            //navigate to add blog screen
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return new AddBlogScreen(
                blog: null,
                isEdit: false,
              );
            }));
          },
          child: Icon(FontAwesomeIcons.solidEdit),
        ));
  }

//blog tile widget
  Widget blogsUi(
    String image,
    String uid,
    String authorname,
    String title,
    String description,
    List<String> likes,
    List<Comment> comments,
    String date,
    String time,
    int timeStamp,
  ) {
    return new Card(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      elevation: 15.0,
      child: new Container(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title ?? '',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Paficico',
                      color: Colors.purple),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              height: 240,
              width: MediaQuery.of(context).size.width / 1.2,
              placeholder: (context, url) => CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.purple[800]),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text(
                      'Author Name: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      authorname ?? '',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[850],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                    child: new Text(
                      time,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
            Row(
              children: <Widget>[
                getClapButton(timeStamp, likes, uid),
                clapcount(likes),
                getCommentButton(timeStamp, comments, uid, title),
                commentCount(comments),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0.5, 0),
              child: new Text(description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.left),
            ),
          ],
        ),
      ),
    );
  }

  Widget getClapButton(int timeStamp, List<String> likes, String uid) {
    return new GestureDetector(
        onTap: () => {
              setState(() {
                if (likes.contains(uid)) {
                  likes.remove(uid);
                } else {
                  likes.add(uid);
                }
              }),
              setlike(timeStamp, likes, uid),
            },
        child: new Container(
          height: 20.0,
          width: 20.0,
          padding: new EdgeInsets.all(0.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(50.0),
            color: Colors.white,
          ),
          child: likes.contains(uid) == true
              ? Icon(Icons.favorite, color: Colors.purple[500], size: 20)
              : Icon(Icons.favorite_border,
                  color: Colors.purple[500], size: 20.0),
        ));
  }

  Widget clapcount(List<String> likes) {
    return new Opacity(
        opacity: 1.0,
        child: new Container(
            height: 10,
            width: 10.0,
            child: new Center(
                child: new Text(
              likes.length.toString(),
              style: new TextStyle(color: Colors.grey[700], fontSize: 10.0),
            ))));
  }

  Widget getCommentButton(
      int timeStamp, List<Comment> comments, String uid, String title) {
    //  print('inside getcomment button ${timeStamp}, ${comments}');

    // print('tempcomment ${tempComment}');
    return new GestureDetector(
      child: new Container(
        alignment: Alignment.center,
        height: 30.0,
        width: 30.0,
        child: IconButton(
            icon: Icon(
              FontAwesomeIcons.comment,
              color: Colors.purple[500],
              size: 15.0,
            ),
            onPressed: () =>
                navigateTocommentPage(timeStamp, comments, uid, title)),
      ),
    );
  }

  Widget commentCount(List<Comment> comments) {
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

  Widget errorUI() {
    return new SnackBar(
        content: Text('Something went wrong try after sometime!!'));
  }
}
