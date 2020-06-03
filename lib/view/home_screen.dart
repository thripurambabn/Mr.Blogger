import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
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
  var userService = UserService();
  static BlogsService _blogsServcie = BlogsService();
  List<Blogs> blogsList = [];
  Blogs blogs;
  BlogsBloc _blog;
  // var _blog = BlogsBloc(blogsService: _blogsServcie);
  @override
  void initState() {
    print('in home initial state');
    _blog = BlocProvider.of<BlogsBloc>(context);
    // _blog.add(
    //   LoadedBlog(blogsList),
    // );
    super.initState();
  }

  void navigateToSignUpPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginScreen(
        userService: userService,
      );
    }));
  }

  void navigateToDetailPage(Blogs blog) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new DetailPage(
        blogs: blog,
      );
    }));
  }

  void navigateToProfilePage() {
    print('navigating to proilepage');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new ProfilePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    // return BlocProvider<BlogsBloc>(
    //   create: (context) => _blogsBloc,
    // child:
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
                print('pressed signout');
                BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationLoggedOut(),
                );
              },
            ),
          ],
        ),
        // body: InkWell(
        body: Container(
          // child: BlocListener<BlogsBloc, BlogsState>(
          //   listener: (context, state) {
          //     if (state is BlogsNotLoaded) {
          //       print('blogs are not loaded');
          //     }
          //   },
          child: BlocBuilder<BlogsBloc, BlogsState>(
            bloc: BlogsBloc(blogsService: _blogsServcie),
            builder: (context, state) {
              print('state before if in homescreen ${state}');
              if (state is BlogsLoading) {
                return Text('blogs loading...${state}');
              } else if (state is BlogsLoaded) {
                return Text('blogs are here ${state.blogs}');
              } else if (state is BlogsNotLoaded) {
                return Text('Not loaded');
              }
            },
          ),
        ),
        // ),
        //onTap: () => navigateToDetailPage(snapshot.data['index']),
        //   ),
        floatingActionButton: RaisedButton(
          color: Colors.purple[800],
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return new AddBlogScreen();
            }));
          },
          child: Text(
            'Upload Your Blog',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          ),
        ));
    //);
  }

  Widget blogsUi(String image, String uid, String authorname, String title,
      String description, String likes, String date, String time) {
    print('authorname in home ${authorname}');
    print('uid in homeUI---${uid}');
    print('${description.length},length');
    print('${title.length}-----title length');
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
                    date,
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

class Blogs {
  String image, uid, authorname, title, description, likes, date, time;
  Blogs(this.image, this.uid, this.authorname, this.title, this.description,
      this.date, this.likes, this.time);
}
