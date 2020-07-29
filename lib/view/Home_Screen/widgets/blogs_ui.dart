import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/models/comment.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/comment_button.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/follow_button.dart';
import 'package:mr_blogger/view/Home_Screen/widgets/like_button.dart';
import 'package:mr_blogger/view/Comment_Screen/comment_screen.dart';

class BlogsUI extends StatefulWidget {
  final List<String> images;
  final String uid;
  final String authorname;
  final String title;
  final String description;
  final List<String> likes;
  final List<Comment> comments;
  final String date;
  final String time;
  final List<String> followers;
  final List<String> following;

  final int timeStamp;
  BlogsUI({
    Key key,
    this.images,
    this.uid,
    this.authorname,
    this.title,
    this.description,
    this.likes,
    this.comments,
    this.date,
    this.time,
    this.timeStamp,
    this.followers,
    this.following,
  }) : super(key: key);

  @override
  _BlogsUIState createState() => _BlogsUIState();
}

class _BlogsUIState extends State<BlogsUI> {
  @override
  Widget build(BuildContext context) {
    navigateTocommentPage(
        int timeStamp, List<Comment> comments, String uid, String title) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return CommentsScreen(timeStamp, comments, uid, title);
      }));
    }

    List<CachedNetworkImage> cachednetworkImages = List<CachedNetworkImage>();
    for (var image in widget.images) {
      cachednetworkImages.add(
        CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          height: 240,
          width: MediaQuery.of(context).size.width / 1.2,
          placeholder: (context, url) => Center(
              child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.purple[800]),
            ),
          )),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    }
    return new Card(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      elevation: 15.0,
      child: new Container(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.title ?? '',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Paficico',
                        color: Colors.purple),
                    textAlign: TextAlign.left,
                  ),
                  FollowButton(
                    timeStamp: widget.timeStamp,
                    followers: widget.followers,
                    following: widget.following,
                    uid: widget.uid,
                  ),
                ]),
            SizedBox(height: 10.0),
            Container(
                height: 200.0,
                width: 350.0,
                child: Carousel(
                  boxFit: BoxFit.contain,
                  images: cachednetworkImages,
                  dotSize: 8.0,
                  dotSpacing: 15.0,
                  dotColor: Colors.purple[800],
                  indicatorBgPadding: 5.0,
                  autoplay: false,
                  dotBgColor: Colors.white.withOpacity(0),
                  borderRadius: true,
                )),
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
                      widget.authorname ?? '',
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
                      widget.time,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
            Row(
              children: <Widget>[
                LikeButton(
                  timeStamp: widget.timeStamp,
                  likes: widget.likes,
                  uid: widget.uid,
                ),
                //   LikeCount(likes: widget.likes),
                CommentButton(
                  timeStamp: widget.timeStamp,
                  comments: widget.comments,
                  uid: widget.uid,
                  title: widget.title,
                  navigateToCommentPage: () {
                    navigateTocommentPage(widget.timeStamp, widget.comments,
                        widget.uid, widget.title);
                  },
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0.5, 0),
              child: new Text(widget.description ?? '',
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
