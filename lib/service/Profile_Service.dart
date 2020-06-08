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
    return blogsList;
  }
}
