import 'package:flutter/material.dart';

class ProfileUI extends StatefulWidget {
  final String uid;
  final String displayname;
  final String imageUrl;
  final String email;
  final List<String> following;
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
      this.uid})
      : super(key: key);

  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  @override
  Widget build(BuildContext context) {
    print('profile_ui ${widget.following}');
    return new Column(children: <Widget>[
      Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 110.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [
                          Colors.purple[400],
                          Colors.purple[300],
                          Colors.purple[900]
                        ],
                        end: FractionalOffset.topCenter),
                    color: Colors.purpleAccent),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(60, 30, 60, 0),
                alignment: Alignment.center,
                child: Stack(children: <Widget>[
                  Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.imageUrl ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG2_068DwPxMkNGtNretnitrJOBG4hJSeYGGyI9yfSaCvRA7Rj&usqp=CAU'),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 6.0)),
                  ),
                  Positioned(
                    top: 100,
                    left: 80,
                    //alignment: Alignment.bottomRight,
                    child: RawMaterialButton(
                      onPressed: widget.buttonPressed,
                      elevation: 0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.edit,
                        size: 25.0,
                        color: Colors.purple[800],
                      ),
                      padding: EdgeInsets.all(0.0),
                      shape: CircleBorder(),
                    ),
                  ),
                ])),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        widget.displayname,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
            fontFamily: 'Paficico',
            color: Colors.purple[600]),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Text('Followers',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      fontFamily: 'Paficico',
                      decoration: TextDecoration.underline,
                      color: Colors.purple[600],
                    )),
                // Text(widget.followers.length.toString(),
                //     style: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       fontSize: 20.0,
                //       fontFamily: 'Paficico',
                //       decoration: TextDecoration.underline,
                //       color: Colors.purple[600],
                //     )),
              ],
            ),
            onTap: widget.navigateToFollowerPage,
          ),
          InkWell(
            child: Row(
              children: <Widget>[
                Text('Following',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      fontFamily: 'Paficico',
                      decoration: TextDecoration.underline,
                      color: Colors.purple[600],
                    )),
                Text(widget.following.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      fontFamily: 'Paficico',
                      decoration: TextDecoration.underline,
                      color: Colors.purple[600],
                    )),
              ],
            ),
            onTap: widget.navigateToFollowerPage,
          ),
        ],
      )
    ]);
  }
}
