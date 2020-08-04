import 'package:flutter/material.dart';

class ProfileUI extends StatefulWidget {
  final String uid;
  final String displayname;
  final String imageUrl;
  final String email;
  final List<String> following;
  final List<String> followers;
  final Function buttonPressed;
  final Function navigateToFollowerPage;
  ProfileUI(
      {Key key,
      this.displayname,
      this.imageUrl,
      this.email,
      this.buttonPressed,
      this.navigateToFollowerPage,
      this.following,
      this.uid,
      this.followers})
      : super(key: key);

  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      Container(
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       border: Border.all(color: Colors.purple[800], width: 0.0)),
        child: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(60, 20, 60, 0),
                alignment: Alignment.center,
                child: Stack(children: <Widget>[
                  Container(
                    height: 130.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.imageUrl ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG2_068DwPxMkNGtNretnitrJOBG4hJSeYGGyI9yfSaCvRA7Rj&usqp=CAU'),
                        ),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.purple[800], width: 0.0)),
                  ),
                  Positioned(
                    top: 83,
                    left: 65,
                    child: RawMaterialButton(
                      onPressed: widget.buttonPressed,
                      elevation: 4,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.edit,
                        size: 25.0,
                        color: Colors.purple[800],
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                ])),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.displayname,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              fontFamily: 'Paficico',
              color: Colors.purple[600]),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey[350])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 75, 0),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Text(widget.following.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          // fontFamily: 'Paficico',
                          color: Colors.purple[600],
                        )),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Following',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          // fontFamily: 'Paficico',
                          color: Colors.purple[600],
                        )),
                  ],
                ),
                onTap: widget.navigateToFollowerPage,
              ),
            ),
            Container(
                height: 20,
                child: VerticalDivider(
                  color: Colors.grey[350],
                  thickness: 2,
                )),
            InkWell(
              child: Row(
                children: <Widget>[
                  Text(widget.followers.length.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        // fontFamily: 'Paficico',
                        color: Colors.purple[600],
                      )),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('Followers',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        // fontFamily: 'Paficico',
                        color: Colors.purple[600],
                      )),
                ],
              ),
              onTap: widget.navigateToFollowerPage,
            ),
          ],
        ),
      ),
    ]);
  }
}
