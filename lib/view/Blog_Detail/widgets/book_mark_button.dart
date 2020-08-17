import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/models/blogs.dart';

class BookMarkButton extends StatefulWidget {
  bool isBookMarked;
  final Blogs blog;

  BookMarkButton({
    Key key,
    this.blog,
    this.isBookMarked,
  }) : super(key: key);
  @override
  _BookMarkButtonState createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends State<BookMarkButton> {
  @override
  Widget build(BuildContext context) {
    void setBookMark(
      bool isBookMarked,
      Blogs blog,
    ) {
      BlocProvider.of<BlogsBloc>(context).add(BookMark(isBookMarked, blog));
    }

    print('bookmark value in book_mark button ${widget.isBookMarked}');
    return new Row(children: <Widget>[
      GestureDetector(
          onTap: () => {
                setState(() {
                  if (widget.isBookMarked) {
                    widget.isBookMarked = false;
                  } else {
                    widget.isBookMarked = true;
                  }
                }),
                setBookMark(
                  widget.isBookMarked,
                  widget.blog,
                ),
              },
          child: widget.isBookMarked == true
              ? Icon(
                  Icons.bookmark,
                  size: 25,
                )
              : Icon(
                  Icons.bookmark_border,
                  size: 25,
                )),
    ]);
  }
}
