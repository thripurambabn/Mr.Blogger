import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/add_blog_screen.dart';
import 'package:mr_blogger/view/blog_detail_Screen.dart';
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
    // print('searching blog');
    // _blogsServcie.searchBlogs(searchbar.text);
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

//navigate to sign Up page
  void navigateToSignUpPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginScreen(
        userService: userService,
      );
    }));
  }

//navigate to detail page page
  void navigateToDetailPage(Blogs blog) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new DetailPage(
        blogs: blog,
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
          backgroundColor: Colors.purple[800],
          title: cusSearchBar,
          actions: <Widget>[
            IconButton(
              icon: cusIcon,
              onPressed: navigateToSerachPage,
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.userCircle),
              onPressed: navigateToProfilePage,
            ),
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
                    return index >= state.blogs.length
                        ? bottomLoader()
                        : ListTile(
                            onTap: () =>
                                navigateToDetailPage(state.blogs[index]),
                            title: blogsUi(
                              state.blogs[index].image,
                              state.blogs[index].uid,
                              state.blogs[index].authorname,
                              state.blogs[index].title,
                              state.blogs[index].description,
                              state.blogs[index].likes,
                              state.blogs[index].date,
                              state.blogs[index].time,
                              state.blogs[index].timeStamp,
                            ));
                  },
                  controller: _scrollController,
                ); //error state
              } else if (state is BlogsNotLoaded) {
                return Text('Not loaded');
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple[800],
          onPressed: () {
            //navigate to add blog screen
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return new AddBlogScreen();
            }));
          },
          // child: Text(
          //   'Upload Your Blog',
          //   style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          // ),
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
      String likes,
      String date,
      String time,
      int timeStamp) {
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
            Image.network(
              image ??
                  Container(
                    color: Colors.purple[50],
                    height: 240,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
              fit: BoxFit.cover,
              height: 240,
              width: MediaQuery.of(context).size.width / 1.2,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Container(
                        color: Colors.purple[50],
                        height: 300,
                        width: MediaQuery.of(context).size.width / 1.2,
                      );
              },
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
            SizedBox(
              height: 10,
            ),
            Container(
              //padding: EdgeInsets.fromLTRB(0, 0, 1, 0),
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
}
