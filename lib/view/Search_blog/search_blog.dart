import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:mr_blogger/Internetconnectivity.dart';
import 'package:mr_blogger/blocs/serach_bloc/search_event.dart';
import 'package:mr_blogger/blocs/serach_bloc/search_state.dart';
import 'package:mr_blogger/blocs/serach_bloc/serach_bloc.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/Blog_Detail/blog_detail_Screen.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/blogs_ui.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Blogs> blogsList = [];
  Blogs blogs;
  bool searching = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchBlogsBloc>(context).add((InitialSearch()));
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
              BlocProvider.of<SearchBlogsBloc>(context)
                  .add(SearchBlog(searchBlog));
            },
          ),
        ),
        //handles blog list view on state change
        body: Builder(builder: (BuildContext context) {
          return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                return InternetConnectivity(
                  child: child,
                  connected: connected,
                );
              },
              child: SingleChildScrollView(
                  child: Container(
                child: Column(children: <Widget>[
                  Container(
                    child: BlocBuilder<SearchBlogsBloc, SearchBlogsState>(
                      bloc: BlocProvider.of<SearchBlogsBloc>(context),
                      builder: (context, state) {
                        //Loading state
                        if (state is SearchInitialState) {
                          return Text('Enter something to search.....',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Paficico',
                                  color: Colors.purple));
                        }
                        if (state is SearchBlogsLoading) {
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
                        else if (state is SearchBlogsLoaded) {
                          return state.blogs.length == 0
                              ? Container(
                                  padding: EdgeInsets.fromLTRB(17, 10, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'No results found for "${searchBlog.text}"...',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Paficico',
                                        color: Colors.purple),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                              : Column(children: <Widget>[
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return index >= state.blogs.length
                                          ? bottomLoader()
                                          : ListTile(
                                              onTap: () => navigateToDetailPage(
                                                  state.blogs[index]),
                                              title: BlogsUI(
                                                isFollowing: state
                                                    .blogs[index].isFollowing,
                                                images:
                                                    state.blogs[index].image,
                                                uid: state.blogs[index].uid,
                                                authorname: state
                                                    .blogs[index].authorname,
                                                title: state.blogs[index].title,
                                                description: state
                                                    .blogs[index].description,
                                                likes: state.blogs[index].likes,
                                                comments:
                                                    state.blogs[index].comments,
                                                date: state.blogs[index].date,
                                                time: state.blogs[index].time,
                                                timeStamp: state
                                                    .blogs[index].timeStamp,
                                              ));
                                    },
                                  )
                                ]);
                          //error state
                        } else if (state is SearchBlogsNotLoaded) {
                          return errorUI();
                        }
                      },
                    ),
                  )
                ]),
              )));
        }));
  }

  Widget errorUI() {
    return new Center(child: Text('there are no blogs of this name'));
  }
}
