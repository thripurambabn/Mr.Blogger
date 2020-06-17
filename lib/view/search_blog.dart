import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/blog_detail_Screen.dart';

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
              onPressed: () => {
                setState(() {
                  if (this.cusIcon.icon == Icons.search) {
                    this.cusIcon = Icon(Icons.cancel);
                    this.cusSearchBar = TextField(
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(border: InputBorder.none),
                      style: TextStyle(
                        color: Colors.purple[300],
                        fontSize: 20.0,
                      ),
                      cursorColor: Colors.purple[400],
                      textCapitalization: TextCapitalization.sentences,
                      controller: searchBlog,
                      onSubmitted: (searchBlog) {
                        _blog.add(SearchBlog(searchBlog));
                      },
                    );
                  } else {
                    this.cusIcon = Icon(Icons.search);
                    this.cusSearchBar = Text('',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Paficico'));
                  }
                }),
              },
            ),
          ],
        ),
        //handles blog list view on state change
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: <Widget>[
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
            Container(
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
                    return errorUI();
                  }
                },
              ),
            )
          ]),
        )));
  }

//blog tile widget
  Widget blogsUi(
      String image,
      String uid,
      String authorname,
      String title,
      String description,
      List<String> likes,
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

Widget errorUI() {
  return new SnackBar(
      content: Text('Something went wrong try after sometime!!'));
}
