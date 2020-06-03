import 'package:firebase_database/firebase_database.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/service/user_service.dart';

class ProfileService {
  var userService = UserService();
  List<Blogs> blogsList = [];
  //List<Users> userlist = [];
  Future<Users> getUserdata() async {
    var user = await userService.getUser();
    // DatabaseReference userref =
    //     FirebaseDatabase.instance.reference().child('users');
    // final DataSnapshot snapshot =
    //     await userref.orderByChild('uid').equalTo(user).once();

    // // var refkey = snapshot.value.keys;
    // var data = snapshot.value;
    // //userlist.clear();
    // print('data in PS ${data}');
    Users userData = new Users(
      user.displayName,
      user.email,
    );
    print('user in profile service${user.displayName}');
    return userData;
    //});
  }

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
          data[key]['date'],
          data[key]['likes'],
          data[key]['time']);
      blogsList.add(blog);
    }

    return blogsList;
  }
}
