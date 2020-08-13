import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:mr_blogger/Internetconnectivity.dart';
import 'package:mr_blogger/blocs/book_marks_bloc/book_marks_bloc.dart';
import 'package:mr_blogger/blocs/book_marks_bloc/book_marks_event.dart';
import 'package:mr_blogger/blocs/book_marks_bloc/book_marks_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/Blog_Detail/blog_detail_Screen.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/blogs_ui.dart';

class BookMarkedPage extends StatefulWidget {
  BookMarkedPage({Key key}) : super(key: key);

  @override
  _BookMarkedPageState createState() => _BookMarkedPageState();
}

class _BookMarkedPageState extends State<BookMarkedPage> {
  @override
  void initState() {
    //calls loaded profile details event
    BlocProvider.of<BookMarkBloc>(context).add(
      BookMarkedBlogs(),
    );
    super.initState();
  }

  void navigateToDetailPage(Blogs blog, String uid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new DetailPage(
        blogs: blog,
        uid: uid,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Text('sadfghjk'),
    // );
    return new Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Colors.purple[800],
              title: Text(
                'Book Marks',
                style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
              ),
            ),
            preferredSize: Size.fromHeight(40.0)),
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
              child: Container(
                child: Container(
                  child: BlocBuilder<BookMarkBloc, BookMarksState>(
                    bloc: BlocProvider.of<BookMarkBloc>(context),
                    builder: (context, state) {
                      if (state is BookMarkedBlogLoading) {
                        return Image.network(
                            'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                      } else if (state is BookMarkedBlogLoaded) {
                        print('blogs ${state.blogs}');
                        return ListView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: state.blogs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                onTap: () => navigateToDetailPage(
                                    state.blogs[index], state.blogs[index].uid),
                                title: BlogsUI(
                                  isFollowing: state.blogs[index].isFollowing,
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
                        );
                      } else if (state is BookMarkedBlogNotLoaded) {
                        return errorUI();
                      }
                    },
                  ),
                ),
              ));
        }));
  }

  Widget errorUI() {
    return new Center(
        child: Text(
      'There are no blogs yet!☹️...\nAdd Yours Now🥳',
      textAlign: TextAlign.center,
      style: TextStyle(
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.purple[200],
              offset: Offset(8.0, 8.0),
            ),
          ],
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Paficico',
          color: Colors.purple),
    ));
  }
}
