import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/models/comment.dart';

class GridUI extends StatefulWidget {
  final List<String> images;
  final String uid;
  final String authorname;
  final String title;
  final String description;
  final List<String> likes;
  final List<Comment> comments;
  final String date;
  final String time;
  final blogBloc;

  final int timeStamp;
  GridUI(
      {Key key,
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
      this.blogBloc})
      : super(key: key);

  @override
  _GridUIState createState() => _GridUIState();
}

class _GridUIState extends State<GridUI> {
  @override
  Widget build(BuildContext context) {
    List<CachedNetworkImage> cachednetworkImages = List<CachedNetworkImage>();
    for (var image in widget.images) {
      cachednetworkImages.add(
        CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          height: 240,
          width: MediaQuery.of(context).size.width / 1.2,
          placeholder: (context, url) => SizedBox(
              height: 20,
              width: 30,
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.purple[800]),
              )),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    }
    return new Card(
      elevation: 15.0,
      margin: EdgeInsets.all(8.0),
      child: new Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  widget.title.substring(0, 9) + '....',
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
            SizedBox(
                height: 200.0,
                width: 350.0,
                child: Carousel(
                  images: cachednetworkImages,
                  dotSize: 8.0,
                  dotSpacing: 15.0,
                  dotColor: Colors.purple[800],
                  indicatorBgPadding: 5.0,
                  autoplay: false,
                  dotBgColor: Colors.white.withOpacity(0),
                  borderRadius: true,
                )),
          ],
        ),
      ),
    );
  }
}
