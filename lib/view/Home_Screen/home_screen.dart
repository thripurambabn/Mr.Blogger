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
import 'package:mr_blogger/view/Add_Edit_Blog/Add_edit_blog_screen.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/blogs_ui.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/bottom_loader.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/error_ui.dart';
import 'package:mr_blogger/view/Profile_Screen/profile_screen.dart';
import 'package:mr_blogger/view/Blog_Detail/blog_detail_Screen.dart';
import 'package:mr_blogger/view/Initial_Screen/initial_screen.dart';
import 'package:mr_blogger/view/Search_blog/search_blog.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //instance of user Service
  static BlogsService _blogsServcie = BlogsService();
  List<Blogs> blogsList = [];
  Blogs blogs;
  final _scrollController = ScrollController();
  var _blog = BlogsBloc(blogsService: _blogsServcie);
  final _scrollThreshold = 200.0;
  bool test = false;

  @override
  void initState() {
    super.initState();
    //listener for scroll event
    print('iam home');
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
  void getBlogs() {
    _blog.add(FetchBlogs());
  }

//loading indicator while fetching more blogs

  var userService = UserService();
  void navigateToProfilePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new ProfilePage();
    }));
  }

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text('Mr.Blogger',
      style: TextStyle(color: Colors.white, fontFamily: 'Paficico'));
  final TextEditingController searchBlog = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void popUpmenuChoice(String choice) {
      if (choice == '1') {
        navigateToProfilePage();
      } else if (choice == '2') {
        BlocProvider.of<AuthenticationBloc>(context)
            .add(AuthenticationLoggedOut());
        Navigator.popUntil(
          context,
          ModalRoute.withName(Navigator.defaultRouteName),
        );
      }
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

//navigate to detail page page
    void navigateToDetailPage(Blogs blog, String uid) {
      //var _blogsBloc = BlocProvider.of<BlogsBloc>(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return new DetailPage(
          blogs: blog,
          uid: uid,
        );
      }));
      // .then((value) {
      //   setState(() => getBlogs);
      // });
    }

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
            // Container(
            //   width: 50,
            //   child:
            PopupMenuButton(
              onCanceled: () {
                print("You have canceled the menu.");
              },
              onSelected: popUpmenuChoice,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                      value: '1',
                      child: Text('Profile',
                          style: TextStyle(
                              color: Colors.purple[800],
                              fontFamily: 'Paficico'))),
                  PopupMenuItem<String>(
                    value: '2',
                    child: Text('Logout',
                        style: TextStyle(
                            color: Colors.purple[800], fontFamily: 'Paficico')),
                  )
                ];
              },
            ),
            // )
          ],
        ),

        //handles blog list view on state change
        body: BlocListener(
          bloc: _blog,
          listener: (context, state) {
            if (state is BlogsLoaded) {
              return ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                itemCount: state.hasReachedMax
                    ? state.blogs.length
                    : state.blogs.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.blogs.length
                      ? BottomLoader()
                      : ListTile(
                          onTap: () => navigateToDetailPage(
                              state.blogs[index], state.uid),
                          title: BlogsUI(
                            blogBloc: _blog,
                            images: state.blogs[index].image,
                            uid: state.blogs[index].uid,
                            authorname: state.blogs[index].authorname,
                            title: state.blogs[index].title,
                            description: state.blogs[index].description,
                            likes: state.blogs[index].likes,
                            comments: state.blogs[index].comments,
                            date: state.blogs[index].date,
                            time: state.blogs[index].time,
                            timeStamp: state.blogs[index].timeStamp,
                          ));
                },
                controller: _scrollController,
              );
            }
          },
          //  Container(
          child: BlocBuilder<BlogsBloc, BlogsState>(
            bloc: _blog,
            builder: (context, state) {
              //Loading state
              print(' widget has been built $state');
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
                        ? BottomLoader()
                        : ListTile(
                            onTap: () => navigateToDetailPage(
                                state.blogs[index], state.uid),
                            title: BlogsUI(
                              blogBloc: _blog,
                              images: state.blogs[index].image,
                              uid: state.blogs[index].uid,
                              authorname: state.blogs[index].authorname,
                              title: state.blogs[index].title,
                              description: state.blogs[index].description,
                              likes: state.blogs[index].likes,
                              comments: state.blogs[index].comments,
                              date: state.blogs[index].date,
                              time: state.blogs[index].time,
                              timeStamp: state.blogs[index].timeStamp,
                            ));
                  },
                  controller: _scrollController,
                ); //error state
              } else if (state is BlogsNotLoaded) {
                return ErrorUI();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple[800],
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddBlogScreen(blog: null, isEdit: false)));
            //     .then((value) {
            //   setState(() => getBlogs());
            // });
          },
          child: Icon(FontAwesomeIcons.solidEdit),
        ));
  }
}
