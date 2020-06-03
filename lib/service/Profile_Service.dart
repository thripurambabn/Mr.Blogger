import 'package:firebase_database/firebase_database.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';
import 'package:mr_blogger/view/profile_screen.dart';

class ProfileService {
  var userService = UserService();
  List<Blogs> blogsList = [];
  List<Users> userlist = [];
  Future<String> getUserdata() async {
    var userid = await userService.getUser();
    print('userdata----- ${userid}');
    DatabaseReference userref =
        FirebaseDatabase.instance.reference().child('users');
    userref
        .orderByChild('uid')
        .equalTo(userid)
        .once()
        .then((DataSnapshot snapshot) {
      print('snapshot in userprofile values---${snapshot.value}');
      print('snapshot in userprofile keys---${snapshot.key}');
      var refkey = snapshot.value.keys;
      var data = snapshot.value;
      userlist.clear();
      for (var key in refkey) {
        Users user = new Users(
          data[key]['username'],
          data[key]['email'],
        );
        userlist.add(user);
        print('user ------${userlist[0].email},${userlist[0].username}');
      }
      // setState(() {
      //   print('total number of users ${userlist.length}');
      // });
    });
  }

  Future getblogs() async {
    var userid = await userService.getUser();
    print('userdata in profile----- ${userid}');
    var username = await userService.getUserName();
    print('username in profile----- ${username}');
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    blogsref
        .orderByChild('uid')
        .equalTo(userid)
        .once()
        .then((DataSnapshot snapshot) {
      var refkey = snapshot.value.keys;
      var data = snapshot.value;
      blogsList.clear();
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

      print('total number of blogs in profile ${blogsList.length}');
    });
  }
}
