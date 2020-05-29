import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';

class AddBlogScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddBlogScreenPage();
  }
}

class _AddBlogScreenPage extends State<AddBlogScreen> {
  File sampleImage;
  final formKey = new GlobalKey<FormState>();
  String _myvalue;
  String _mytitlevalue;
  String category;
  String likes;
  String url;
  bool isbuttondisabled = false;
  var userService = UserService();
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text(
            'Add blog',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          ),
        ),
        body: SingleChildScrollView(
          child: new Center(
            child: sampleImage == null ? beforeUpload() : enableUplaod(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            content: new Text(
              'Are you sure you want to go back?',
              style:
                  TextStyle(color: Colors.purple[500], fontFamily: 'Paficico'),
            ),
            actions: <Widget>[
              Container(
                  child: new OutlineButton(
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop(false),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0)),
                    child: new Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.purple[500], fontFamily: 'Paficico'),
                    ),
                  ),
                  width: 80),
              Container(
                child: new RaisedButton(
                  color: Colors.purple[500],
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Paficico')),
                ),
                width: 80,
              ),
            ],
          ),
        )) ??
        false;
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateandSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
  }

  void uploadImage() async {
    print('inside uploadImage');
    if (validateandSave()) {
      final StorageReference iamgeref =
          FirebaseStorage.instance.ref().child("Blog images");
      var timekey = new DateTime.now();
      final StorageUploadTask uploadImage =
          iamgeref.child(timekey.toString() + '.jpg').putFile(sampleImage);
      var imageurl = await (await uploadImage.onComplete).ref.getDownloadURL();
      url = imageurl.toString();
      //  print("image url ${url}");
      navigateToHomePage();
      try {
        saveToDatabase(url);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void navigateToHomePage() {
    print('navigating to homescreen');
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return new Homepage();
      },
    ));
  }

  void saveToDatabase(String url) async {
    try {
      print('saving to DB');
      var dbkey = new DateTime.now();
      var formatdate = new DateFormat('MMM d,yyyy');
      var formattime = new DateFormat('EEEE, hh:mm aaa');
      String date = formatdate.format(dbkey);
      String time = formattime.format(dbkey);
      var userid = await userService.getUser();
      var username = await userService.getUserName();
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      var data = {
        'image': url,
        'uid': userid,
        'authorname': username,
        'catergory': category,
        'title': _mytitlevalue,
        'description': _myvalue,
        'date': date,
        'time': time
      };
      databaseReference.child('blogs').push().set(data);
      print('saving to DB in the end');
      // Firestore.instance.collection("blogs").document(time).setData({
      //   'iamge': url,
      //   'catergory': category,
      //   'Description': _myvalue,
      //   'date': date,
      //   'time': time,
      //   'likes': likes,
      // });
    } catch (e) {
      print('error in saving db ${e.toString()}');
    }
  }

  Widget enableUplaod() {
    return new Container(
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            dropbox(),
            title(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              child: Image.file(
                sampleImage,
                height: 255.0,
                width: 340,
              ),
              onTap: getImage,
            ),
            SizedBox(
              height: 10.0,
            ),
            descriptionfield(),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text(
                'Upload blog',
                style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
              ),
              color: Colors.purple[800],
              onPressed: isbuttondisabled
                  ? null
                  : () {
                      setState(() => isbuttondisabled = !isbuttondisabled);
                      print('${isbuttondisabled}');
                      print('upload blog pressed');
                      uploadImage();
                    },
            )
          ],
        ),
      ),
    );
  }

  beforeUpload() {
    return new Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          dropbox(),
          title(),
          SizedBox(
            height: 20,
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
              color: Colors.purple[300],
              alignment: Alignment.center,
              height: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.solidImages,
                    ),
                    tooltip: 'Add photo',
                    iconSize: 50,
                    color: Colors.white,
                    splashColor: Colors.purple,
                    onPressed: getImage,
                  ),
                  Text(
                    'Add Photo',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.purple, fontFamily: 'Paficico'),
                  )
                ],
              ),
              width: 340,
            ),
            onTap: getImage,
          ),
          SizedBox(
            height: 10,
          ),
          descriptionfield()
        ],
      ),
    );
  }

  dropbox() {
    String dropdownValue;
    return Container(
      width: 340,
      padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.purple[400])),
      alignment: Alignment.bottomLeft,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            "Select category",
            style: TextStyle(color: Colors.purple[200]),
          ),
          isDense: true,
          value: dropdownValue,
          icon: Icon(FontAwesomeIcons.sortDown),
          iconSize: 30,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              print('before new value $dropdownValue new value $newValue');
              dropdownValue = newValue;
              print('new value $dropdownValue new value $newValue');
            });
          },
          items: <String>['Pets', 'Travel', 'Books', 'Lifestyle', 'Movies']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  descriptionfield() {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Description:',
            style: TextStyle(
                fontFamily: 'Paficico',
                color: Colors.purple[500],
                fontSize: 18),
            textAlign: TextAlign.left,
          ),
        ),
        new Scrollbar(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              textAlign: TextAlign.left,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 5,
              decoration: new InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.purple[300])),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.purple, width: 1.0),
                  ),
                  hintText: 'Write Something...',
                  hintStyle: TextStyle(color: Colors.purple[200])),
              validator: (value) {
                return value.isEmpty ? 'blog decription is required' : null;
              },
              onSaved: (value) {
                _myvalue = value;
              },
            ),
          )),
        ),
      ],
    ));
  }

  title() {
    return Container(
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            'TITLE:',
            style: TextStyle(fontFamily: 'Paficico', color: Colors.purple[500]),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            textAlign: TextAlign.left,
            //   keyboardType: TextInputType.multiline,
            maxLines: 4,
            minLines: 1,
            decoration: new InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.purple)),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.purple, width: 1.0),
                ),
                hintText: 'Enter your title',
                hintStyle: TextStyle(color: Colors.purple[200])),
            validator: (value) {
              return value.isEmpty ? 'Title for your blog is required' : null;
            },
            onSaved: (value) {
              _mytitlevalue = value;
            },
          ),
        )
      ]),
    );
  }
}
