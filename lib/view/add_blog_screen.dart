import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  String category;
  String likes;
  String url;
  bool isbuttondisabled = false;
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
      print("image url ${url}");
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

  void saveToDatabase(String url) {
    try {
      print('saving to DB');
      var dbkey = new DateTime.now();
      var formatdate = new DateFormat('MMM d,yyyy');

      var formattime = new DateFormat('EEEE, hh:mm aaa');
      String date = formatdate.format(dbkey);
      String time = formattime.format(dbkey);

      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      var data = {
        'image': url,
        'catergory': category,
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getImage,
      //   child: Icon(FontAwesomeIcons.upload, color: Colors.white),
      //   backgroundColor: Colors.purple[800],
      // ),
    );
  }

  Widget enableUplaod() {
    return new Container(
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(sampleImage, height: 300.0, width: 350),
            SizedBox(
              height: 30.0,
            ),
            dropbox(),
            SizedBox(
              height: 30.0,
            ),
            descriptionfield(),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              child: Text(
                'Upload blog',
                style: TextStyle(color: Colors.white),
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
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.purple[300]),
            padding: EdgeInsets.all(50.0),
            alignment: Alignment.center,
            height: 300,
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.solidImages,
              ),
              tooltip: 'Add photo',
              iconSize: 50,
              color: Colors.white,
              splashColor: Colors.purple,
              onPressed: getImage,
            ),
            width: 350,
          ),
          SizedBox(
            height: 20,
          ),
          dropbox(),
          SizedBox(
            height: 20,
          ),
          descriptionfield()
        ],
      ),
    );
  }

  dropbox() {
    String dropdownValue;
    return Container(
      alignment: Alignment.bottomLeft,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
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
      child: new Scrollbar(
        child: SingleChildScrollView(
          child: TextFormField(
            textAlign: TextAlign.left,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            minLines: 5,
            decoration: new InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide:
                        BorderSide(width: 1, color: Colors.purple[300])),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.purple, width: 1.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.purple[200])),
            validator: (value) {
              return value.isEmpty ? 'blog decription is required' : null;
            },
            onSaved: (value) {
              _myvalue = value;
            },
          ),
        ),
      ),
    );
  }
}
