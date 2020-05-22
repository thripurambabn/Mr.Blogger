import 'dart:io';
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
  String url;
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
        return new HomeScreen();
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
        'iamge': url,
        'catergory': category,
        'Description': _myvalue,
        'date': date,
        'time': time
      };
      databaseReference.child('blogs').push().set(data);
      print('saving to DB in the end');
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
      body: new Center(
        child: sampleImage == null ? Text('select an iamge') : enableUplaod(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(FontAwesomeIcons.upload, color: Colors.white),
        backgroundColor: Colors.purple[800],
      ),
    );
  }

  Widget enableUplaod() {
    // String dropdownValue = 'One';
    return new Container(
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(sampleImage, height: 310.0, width: 600),
            SizedBox(
              height: 15.0,
            ),
            // DropdownButton<String>(
            //   value: dropdownValue,
            //   icon: Icon(FontAwesomeIcons.dropbox),
            //   iconSize: 24,
            //   elevation: 16,
            //   style: TextStyle(color: Colors.deepPurple),
            //   underline: Container(
            //     height: 2,
            //     color: Colors.deepPurpleAccent,
            //   ),
            //   onChanged: (String newValue) {
            //     setState(() {
            //       dropdownValue = newValue;
            //     });
            //   },
            //   items: <String>['Pets', 'Travel', 'Books', 'Lifestyle', 'Movies']
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              validator: (value) {
                return value.isEmpty ? 'blog decription is required' : null;
              },
              onSaved: (value) {
                _myvalue = value;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              child: Text(
                'upload blog',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.purple[800],
              onPressed: () {
                print('upload blog pressed');
                uploadImage();
              },
            )
          ],
        ),
      ),
    );
  }
}
