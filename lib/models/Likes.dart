class Likes {
  String uid;
  Likes(
    this.uid,
  ) : super();

  factory Likes.fromJson(Map<String, dynamic> parsedJson) {
    return Likes(
      parsedJson['uid'] ?? '',
    );
  }
}
