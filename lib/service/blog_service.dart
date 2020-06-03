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

//To fetch list of blogs from the firebase database
  Future<List<Blogs>> getblogs() async {
    List<Blogs> blogsList = [];
    var userid = await userService.getUser();
    // print('userdata in blogs service----- ${userid}');
    var username = await userService.getUserName();
    //print('username in blogs service----- ${username}');
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    final DataSnapshot snapshot = await blogsref.once();
    //blogsref.once().then((DataSnapshot snapshot) {
    var refkey = snapshot.value.keys;
    var data = snapshot.value;
    //  print('data ${data}');
    // blogsList.clear();
    for (var key in refkey) {
      Blogs blog = new Blogs(
          data[key]['image'],
          data[key]['uid'],
          data[key]['authorname'],
          data[key]['title'],
          data[key]['description'],
          data[key]['date'],
          data[key]['likes'],
          data[key]['time']);
      // print('blog--------${blog}');
      blogsList.add(blog);
    }
    print('blogs length ${blogsList.length}');
    print('blogs in service ${blogsList}');
    return blogsList;
    // });
  }

//To save new blog to the firebase database
  Future<void> saveToDatabase(
    String url,
    String _mytitlevalue,
    String _myvalue,
    String category,
  ) async {
    try {
      print('saving to DB ${url},${_mytitlevalue},${_myvalue}');
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
    print("image url ${url}");
    print('navigating to homescreen');
    // Navigator.push(ctx, MaterialPageRoute(
    //   builder: (ctx) {
    //     return new Homepage();
    //   },
    // ));

    try {
      saveToDatabase(
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
