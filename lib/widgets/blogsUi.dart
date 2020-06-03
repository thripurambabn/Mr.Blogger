import 'package:flutter/material.dart';

class BlogsUi {
  BlogsUi(String image, String uid, String authorname, String title,
      String description, String likes, String date, String time);

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
                    // style: Theme.of(context).textTheme.subtitle1,
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
                // style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }
}
