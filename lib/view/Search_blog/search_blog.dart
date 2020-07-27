import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/Blog_Detail/blog_detail_Screen.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/blogs_ui.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //instance of user Service
  var userService = UserService();
  static BlogsService _blogsServcie = BlogsService();
  List<Blogs> blogsList = [];
  Blogs blogs;
  final _scrollController = ScrollController();
  var _blog = BlogsBloc(blogsService: _blogsServcie);
  final _scrollThreshold = 200.0;
  bool searching = false;
  @override
  void initState() {
    super.initState();
    //listener for scroll event
    _scrollController.addListener(_onScroll);
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

//navigate to detail page page
  void navigateToDetailPage(Blogs blog) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new DetailPage(
        blogs: blog,
      );
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
  final TextEditingController searchBlog = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: TextField(
            autofocus: true,
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: () => searchBlog.clear(),
                icon: Icon(Icons.cancel, color: Colors.white),
              ),
            ),
            style: TextStyle(
              color: Colors.purple[300],
              fontSize: 20.0,
            ),
            cursorColor: Colors.purple[400],
            textCapitalization: TextCapitalization.sentences,
            controller: searchBlog,
            onSubmitted: (searchBlog) {
              setState(() {
                searching = true;
              });
              _blog.add(SearchBlog(searchBlog));
            },
          ),
        ),
        //handles blog list view on state change
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: <Widget>[
            Container(
              child: BlocBuilder<BlogsBloc, BlogsState>(
                bloc: _blog,
                builder: (context, state) {
                  //Loading state
                  if (state is BlogsLoading) {
                    return Column(children: <Widget>[
                      Image.network(
                        'https://www.goodtoseo.com/wp-content/uploads/2017/09/blog_sites.gif',
                        alignment: Alignment.center,
                      ),
                      Text('wait iam searching.....',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Paficico',
                              color: Colors.purple))
                    ]);
                  } //Loaded state
                  else if (state is BlogsLoaded) {
                    print('state of blogs in search ui ${state.blogs.length}');
                    return Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(17, 10, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Results for "${searchBlog.text}"...',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Paficico',
                              color: Colors.purple),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
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
                                  title: BlogsUI(
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
                      )
                    ]);
                    //error state
                  } else if (state is BlogsNotLoaded) {
                    return errorUI();
                  }
                },
              ),
            )
          ]),
        )));
  }

  Widget errorUI() {
    return new Center(child: Text('there are no blogs of this name'));
  }
}
