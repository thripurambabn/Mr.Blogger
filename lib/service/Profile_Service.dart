import 'package:firebase_database/firebase_database.dart';
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
              likes: data[key]['likes'],
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
}
