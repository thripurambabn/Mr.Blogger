import 'package:flutter/material.dart';

class EditProfileUI extends StatefulWidget {
  final String imageUrl;
  final Function getImage;
  final TextEditingController nameController;
  EditProfileUI({Key key, this.imageUrl, this.getImage, this.nameController})
      : super(key: key);

  @override
  _EditProfileUIState createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
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
                )
              ],
            ),
            Positioned(
                top: 30.0,
                child: InkWell(
                  onTap: () => {print('tapping'), widget.getImage()},
                  child: Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.imageUrl != null
                              ? widget.imageUrl
                              : widget.imageUrl ??
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG2_068DwPxMkNGtNretnitrJOBG4hJSeYGGyI9yfSaCvRA7Rj&usqp=CAU'),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 6.0)),
                  ),
                )),
          ],
        ),
      ),
      SizedBox(
        height: 70,
      ),
      Container(
        padding: EdgeInsets.all(15),
        child: TextFormField(
          controller: widget.nameController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.person,
              color: Colors.purple[800],
            ),
            labelText: 'Username',
          ),
          autocorrect: false,
          autovalidate: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    ]);
  }
}
