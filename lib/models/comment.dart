class Comment {
  String usernamename, date, comment;
  Comment({this.date, this.comment, username});

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    return Comment(
      username: parsedJson['username'] ?? '',
      date: parsedJson['date'] ?? '',
      comment: parsedJson['comment'] ?? '',
    );
  }
}
