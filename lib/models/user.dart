// class Users {
//   String displayName, email, uid, imageUrl;
//   List<String> followers;
//   Users(
//       {this.displayName, this.email, this.uid, this.imageUrl, this.followers});
//   factory Users.fromJson(Map<String, dynamic> parsedJson) {
//     return Users(
//         displayName: parsedJson['username'] ?? '',
//         email: parsedJson['email'] ?? '',
//         uid: parsedJson['uid'] ?? '',
//         imageUrl: parsedJson['imageUrl'] ?? '',
//         followers: parsedJson['followers'] ?? null);
//   }
// }

class Users {
  static final Users _user = Users._internal();
  String displayName, email, uid, imageUrl;
  List<String> followers;
  factory Users() => _user;
  factory Users.fromJson(parsedJson) {
    List _listData;

    var _list = parsedJson.values.toList();

    for (var listValue in _list) {
      _listData.add(listValue);
    }
    print(
        'listData  ${_listData[0]}${_listData[0].length}\n ${_listData[0].runtimeType}\n ');
    _user.displayName = parsedJson['username'] ?? '';
    _user.email = parsedJson['email'] ?? '';
    _user.uid = parsedJson['uid'] ?? '';
    _user.imageUrl = parsedJson['photoUrl'] ?? '';
    _user.followers = parsedJson['followers'] ?? null;
    return _user;
  }

  Users._internal();
}
