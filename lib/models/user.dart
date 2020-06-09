class Users {
  String displayName, email, uid;
  Users({this.displayName, this.email, this.uid});
  factory Users.fromJson(Map<String, dynamic> parsedJson) {
    return Users(
        displayName: parsedJson['username'] ?? '',
        email: parsedJson['email'] ?? '',
        uid: parsedJson['uid'] ?? '');
  }
}
