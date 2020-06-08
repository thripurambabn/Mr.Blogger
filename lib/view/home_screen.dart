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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text('Mr.Blogger',
              style: TextStyle(color: Colors.white, fontFamily: 'Paficico')),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.userCircle),
              onPressed: navigateToProfilePage,
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationLoggedOut(),
                );
              },
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
                return Text('blogs loading...${state}');
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
        floatingActionButton: RaisedButton(
          color: Colors.purple[800],
          onPressed: () {
            //navigate to add blog screen
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return new AddBlogScreen();
            }));
          },
          child: Text(
            'Upload Your Blog',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          ),
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
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title.substring(0, 9) + '....',
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
              image,
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
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'By: ' + authorname,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.right,
                  ),
                  new Text(
                    time,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[350],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ]),
            SizedBox(
              height: 10,
            ),
            Container(
              child: new Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }
}
