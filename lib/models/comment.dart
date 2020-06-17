class Comment {
  String username, comment;
  int date;
  Comment({this.date, this.comment, this.username});

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    return Comment(
      username: parsedJson['username'] ?? '',
      date: parsedJson['date'] ?? '',
      comment: parsedJson['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => _dimensionsToJson(this);
}

Map<String, dynamic> _dimensionsToJson(Comment comment) => <String, dynamic>{
      'username': comment.username,
      'date': comment.date,
      'comment': comment.comment,
    };
