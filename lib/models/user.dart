import 'package:mr_blogger/models/blogs.dart';

class Users {
  String displayName, email, uid, imageUrl;
  List<String> following;
  List<String> followers;
  List<Blogs> bookMarks;
  Users(
      {this.displayName,
      this.email,
      this.uid,
      this.imageUrl,
      this.followers,
      this.following,
      this.bookMarks});
  factory Users.fromJson(Map<String, dynamic> parsedJson) {
    return Users(
        displayName: parsedJson['username'] ?? '',
        email: parsedJson['email'] ?? '',
        uid: parsedJson['uid'] ?? '',
        imageUrl: parsedJson['imageUrl'] ?? '',
        followers: parsedJson['followers'] ?? null,
        following: parsedJson['following'] ?? null,
        bookMarks: parsedJson['bookMarks'] ?? null);
  }
}

// class Users {
//   static final Users _user = Users._internal();
//   String displayName, email, uid, imageUrl;
//   List<String> following;
//   List<String> followers;
//   factory Users() => _user;
//   factory Users.fromJson(parsedJson) {
//     List _listData = [];

//     var _list = parsedJson.values.toList();

//     for (var listValue in _list) {
//       _listData.add(listValue);
//     }
//     var tempfollowing = [];
//     var followingList = List<String>();
//     if (_listData[0]['following'] != null) {
//       tempfollowing = _listData[0]['following'];
//       for (var follower in tempfollowing) {
//         followingList.add(follower.toString());
//       }
//     }
//     var tempfollowers = [];
//     var followersList = List<String>();
//     if (_listData[0]['followers'] != null) {
//       tempfollowers = _listData[0]['followers'];
//       for (var follower in tempfollowers) {
//         followersList.add(follower.toString());
//       }
//     }
//     _user.displayName = _listData[0]['username'] ?? '';
//     _user.email = _listData[0]['email'] ?? '';
//     _user.uid = _listData[0]['uid'] ?? '';
//     _user.imageUrl = _listData[0]['photoUrl'] ?? '';
//     _user.following = followingList ?? null;
//     _user.followers = followersList ?? null;
//     return _user;
//   }

//   Users._internal();
// }
