import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/user_service.dart';

class BlogsService {
  var userService = UserService();
  List<Blogs> blogsList = [];
  int value = 2;

//To fetch first set of blogs from the firebase database
  Future<List<Blogs>> getblogs() async {
    List<Blogs> blogsList = [];
    Query blogsref = FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('timeStamp')
        .limitToFirst(value);
    final DataSnapshot snapshot = await blogsref.once();
    var refkey = snapshot.value.keys;
    var data = snapshot.value;
    for (var key in refkey) {
      Blogs blog = new Blogs(
        data[key]['image'],
        data[key]['uid'],
        data[key]['authorname'],
        data[key]['title'],
        data[key]['description'],
        data[key]['likes'],
        data[key]['date'],
        data[key]['time'],
        data[key]['timeStamp'],
      );
      blogsList.add(blog);
    }
    //sort blogs on timestamp
    blogsList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    return blogsList;
  }

//To fetch more blogs from the firebase database on scroll(pagination)
  Future<List<Blogs>> getMoreBlogs(List<Blogs> blogs) async {
    List<Blogs> blogsList = [];

    var queryTimeStamp = blogs[blogs.length - 1].timeStamp;
    Query blogsref = FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('timeStamp')
        .startAt(queryTimeStamp + 1)
        .limitToFirst(value);
    final DataSnapshot snapshot = await blogsref.once();
    try {
      if (snapshot.value != null) {
        var refkey = snapshot.value.keys;
        var data = snapshot.value;
        for (var key in refkey) {
          Blogs blog = new Blogs(
              data[key]['image'],
              data[key]['uid'],
              data[key]['authorname'],
              data[key]['title'],
              data[key]['description'],
              data[key]['likes'],
              data[key]['date'],
              data[key]['time'],
              data[key]['timeStamp']);
          blogsList.add(blog);
        }
      }
    } catch (e) {
      print(e);
    }
    //sort blogs on timestamp
    blogsList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    return blogsList;
  }

//To add new blog to the firebase database
  Future<void> saveToDatabase(
    String url,
    String _mytitlevalue,
    String _myvalue,
    String category,
  ) async {
    try {
      var dbkey = new DateTime.now();
      var formatdate = new DateFormat('MMM d,yyyy');
      var formattime = new DateFormat('EEEE, hh:mm aaa');
      String date = formatdate.format(dbkey);
      String time = formattime.format(dbkey);
      var userid = await userService.getUserID();
      var username = await userService.getUserName();
      var timeStamp = new DateTime.now().millisecondsSinceEpoch;
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      var data = {
        'image': url,
        'uid': userid,
        'authorname': username,
        'title': _mytitlevalue,
        'description': _myvalue,
        'date': date,
        'time': time,
        'timeStamp': timeStamp,
      };
      databaseReference.child('blogs').push().set(data);
    } catch (e) {
      print('error in saving db ${e.toString()}');
    }
  }

//To Upload image to the firebase storage
  Future<void> uploadImage({
    sampleImage,
    url,
    mytitlevalue,
    myvalue,
    category,
  }) async {
    String url;
    // if (validateandSave()) {
    final StorageReference iamgeref =
        FirebaseStorage.instance.ref().child("Blog images");
    var timekey = new DateTime.now();
    final StorageUploadTask uploadImage =
        iamgeref.child(timekey.toString() + '.jpg').putFile(sampleImage);
    var imageurl = await uploadImage.onComplete;
    var imageurl1 = await imageurl.ref.getDownloadURL();
    url = imageurl1.toString();

    try {
      await saveToDatabase(
        url,
        mytitlevalue,
        myvalue,
        category,
      );
    } catch (e) {
      print(e.toString());
    }
    // }
  }

//To validate form and save
  bool validateandSave() {
    final formKey = new GlobalKey<FormState>();
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
  }
}
