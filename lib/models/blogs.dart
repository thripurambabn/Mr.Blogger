import 'package:mr_blogger/models/comment.dart';

class Blogs {
  String image, uid, authorname, title, description, date, time;
  List<String> likes;
  List<Comment> comments;
  int timeStamp;
  Blogs(
      {this.image,
      this.uid,
      this.authorname,
      this.title,
      this.description,
      this.date,
      this.likes,
      this.comments,
      this.time,
      this.timeStamp})
      : super();

  factory Blogs.fromJson(Map<String, dynamic> parsedJson) {
    return Blogs(
        image: parsedJson['image'] ?? '',
        uid: parsedJson['uid'] ?? '',
        authorname: parsedJson['authorname'] ?? '',
        title: parsedJson['title'] ?? '',
        description: parsedJson['description'] ?? '',
        likes: parsedJson['likes'] ?? null,
        comments: parsedJson['comments'] ?? null,
        date: parsedJson['date'] ?? '',
        time: parsedJson['time'] ?? '',
        timeStamp: parsedJson['timeStamp'] ?? '');
  }
}
