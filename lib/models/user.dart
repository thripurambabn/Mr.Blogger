class Users {
  String displayName, email, uid, imageUrl;
  Users({this.displayName, this.email, this.uid, this.imageUrl});
  factory Users.fromJson(Map<String, dynamic> parsedJson) {
    return Users(
        displayName: parsedJson['username'] ?? '',
        email: parsedJson['email'] ?? '',
        uid: parsedJson['uid'] ?? '',
        imageUrl: parsedJson['imageUrl'] ?? '');
  }
}
