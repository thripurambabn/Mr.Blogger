import 'package:mr_blogger/models/Likes.dart';

class Blogs {
  String image, uid, authorname, title, description, date, time;
  List<String> likes;
  int timeStamp;
  Blogs(
      {this.image,
      this.uid,
      this.authorname,
      this.title,
      this.description,
      this.date,
      this.likes,
      this.time,
      this.timeStamp})
      : super();

  factory Blogs.fromJson(Map<String, dynamic> parsedJson) {
    // if (parsedJson['likes'] != null) {
    //   var likesObjsJson = parsedJson['likes'] as List;
    //   List<Likes> _likes =
    //       likesObjsJson.map((likesJson) => Likes.fromJson(likesJson)).toList();
    return Blogs(
        image: parsedJson['image'] ?? '',
        uid: parsedJson['uid'] ?? '',
        authorname: parsedJson['authorname'] ?? '',
        title: parsedJson['title'] ?? '',
        description: parsedJson['description'] ?? '',
        likes: parsedJson['description'] ?? null,
        date: parsedJson['date'] ?? '',
        time: parsedJson['time'] ?? '',
        timeStamp: parsedJson['timeStamp'] ?? '');
  }

  // Map<String, dynamic> toJSON() => {
  //       'image': image,
  //       'uid': uid,
  //       'authorname': authorname,
  //       'title': title,
  //       'description': description,
  //       'likes': likes,
  //       'date': date,
  //       'time': time,
  //       'timeStamp': timeStamp
  //     };
}
