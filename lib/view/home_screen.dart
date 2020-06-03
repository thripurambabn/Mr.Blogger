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
import 'package:mr_blogger/widgets/blogsUi.dart';

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
  //BlogsBloc _blog;
  var _blog = BlogsBloc(blogsService: _blogsServcie);
  @override
  void initState() {
    print('in home initial state');
    super.initState();
    //  _blogsBloc = BlocProvider.of<BlogsBloc>(context);
    _blog.add(
      FetchBlogs(),
    );
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
          child: BlocBuilder<BlogsBloc, BlogsState>(
            bloc: _blog,
            builder: (context, state) {
              if (state is BlogsLoading) {
                return Text('blogs loading...${state}');
              } else if (state is BlogsLoaded) {
                return ListView.builder(
                  itemCount: state.blogs.length,
                  itemBuilder: (BuildContext context, int index) {
                    // print(
                    //     'list tile value in blocbuilder ${state.blogs[index].authorname},${index}');
                    return ListTile(
                        onTap: () => navigateToDetailPage(state.blogs[index]),
                        title: blogsUi(
                            state.blogs[index].image,
                            state.blogs[index].uid,
                            state.blogs[index].authorname,
                            state.blogs[index].title,
                            state.blogs[index].description,
                            state.blogs[index].likes,
                            state.blogs[index].date,
                            state.blogs[index].time));
                  },
                );
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
    // print('authorname in home ${authorname}');
    // print('uid in homeUI---${uid}');
    // print('${description.length},length');
    // print('${title.length}-----title length');
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
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
// import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
// import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
// import 'package:mr_blogger/models/blogs.dart';
// import 'package:mr_blogger/service/blog_service.dart';

// class Homepage extends StatefulWidget {
//   Homepage({Key key}) : super(key: key);

//   @override
//   _HomepageState createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
// //  BlogsBloc _blogsBloc;
//   static BlogsService _blogsService;
//   List<Blogs> blogsList = [];
//   var _blog = BlogsBloc(blogsService: _blogsService);
//   @override
//   void initState() {
//     print('in home initial state');
//     super.initState();
//     //  _blogsBloc = BlocProvider.of<BlogsBloc>(context);
//     _blog.add(
//       FetchBlogs(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BlogsBloc, BlogsState>(
//       bloc: _blog,
//       builder: (context, state) {
//         print('state in blocbuilder ${state}');
//         if (state is BlogsLoading) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         if (state is BlogsNotLoaded) {
//           return Center(
//             child: Text('failed to fetch blogs'),
//           );
//         }
//         if (state is BlogsLoaded) {
//           if (state.blogs.isEmpty) {
//             return Center(
//               child: Text('no blogs'),
//             );
//           }
//           return ListView.builder(
//             itemBuilder: (BuildContext context, int index) {
//               print(
//                   'list tile value in blocbuilder ${state.blogs[index].authorname}');
//               return BlogsWidget(blog: state.blogs[index]);
//             },
//           );
//         }
//       },
//     );
//   }
// }

// class BlogsWidget extends StatelessWidget {
//   final Blogs blog;

//   const BlogsWidget({Key key, @required this.blog}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print('in widget build ${blog.authorname}');
//     return Card(
//         child: ListTile(
//       title: Text(blog.title),
//       subtitle: Text(blog.description),
//     ));
//   }
// }
