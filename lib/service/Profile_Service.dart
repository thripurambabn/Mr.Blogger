import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/user_service.dart';

class ProfileService {
  var userService = UserService();
  List<Blogs> blogsList = [];

//To fetch blogs of logged in user
  Future getblogs() async {
    var userid = await userService.getUserID();
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    final DataSnapshot snapshot =
        await blogsref.orderByChild('uid').equalTo(userid).once();
    try {
      if (snapshot.value != null) {
        var refkey = snapshot.value.keys;
        var data = snapshot.value;
        for (var key in refkey) {
          Blogs blog = new Blogs(
              image: data[key]['image'],
              uid: data[key]['uid'],
              authorname: data[key]['authorname'],
              title: data[key]['title'],
              description: data[key]['description'],
              date: data[key]['date'],
              time: data[key]['time'],
              timeStamp: data[key]['timeStamp']);
          blogsList.add(blog);
        }
      } else {
        print('there are no blogs of this user');
      }
    } catch (e) {
      print(e);
    }
    return blogsList;
  }

//To delete a blog from firebase
  Future deleteBlog(String key) {
    FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('title')
        .equalTo(key)
        .onChildAdded
        .listen((Event event) {
      FirebaseDatabase.instance
          .reference()
          .child('blogs')
          .child(event.snapshot.key)
          .remove();
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  Future updateBlog(url, mytitlevalue, myvalue, category, blogtimeStamp) {
    try {
      var dbkey = new DateTime.now();
      var formatdate = new DateFormat('MMM d,yyyy');
      var formattime = new DateFormat('EEEE, hh:mm aaa');
      String date = formatdate.format(dbkey);
      String time = formattime.format(dbkey);

      var data = {
        'image': url,
        'title': mytitlevalue,
        'description': myvalue,
        'date': date,
        'time': time,
      };
      FirebaseDatabase.instance
          .reference()
          .child('blogs')
          .orderByChild('timeStamp')
          .equalTo(blogtimeStamp)
          .onChildAdded
          .listen((Event event) {
        FirebaseDatabase.instance
            .reference()
            .child('blogs')
            .child(event.snapshot.key)
            .update(data);
      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
      });
    } catch (e) {
      print('e');
    }
  }

  Future<void> updateImage(
      {sampleImage,
      url,
      mytitlevalue,
      myvalue,
      category,
      blogtimeStamp}) async {
    String url;
    final StorageReference iamgeref =
        FirebaseStorage.instance.ref().child("Blog images");
    var timekey = new DateTime.now();
    final StorageUploadTask updateImage =
        iamgeref.child(timekey.toString() + '.jpg').putFile(sampleImage);
    var imageurl = await updateImage.onComplete;
    var imageurl1 = await imageurl.ref.getDownloadURL();
    url = imageurl1.toString();
    try {
      await updateBlog(url, mytitlevalue, myvalue, category, blogtimeStamp);
    } catch (e) {
      print(e.toString());
    }
  }

  Future editProfile(name) async {
    try {
      final FirebaseAuth firebaseAuth1 = FirebaseAuth.instance;
      final FirebaseUser user = await firebaseAuth1.currentUser();
      var addusername = UserUpdateInfo();

      addusername.displayName = name;
      await user.updateProfile(addusername);
      await user.reload();
      var data = {
        'username': name,
      };
      var authordata = {
        'authorname': name,
      };
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .orderByChild('uid')
          .equalTo(user.uid)
          .onChildAdded
          .listen((Event event) {
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(event.snapshot.key)
            .update(data);
      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
      });
      FirebaseDatabase.instance
          .reference()
          .child('blogs')
          .orderByChild('uid')
          .equalTo(user.uid)
          .onChildAdded
          .listen((Event event) {
        FirebaseDatabase.instance
            .reference()
            .child('blogs')
            .child(event.snapshot.key)
            .update(authordata);
      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
      });
    } catch (e) {
      print('e');
    }
  }
}
