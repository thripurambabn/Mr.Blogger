import 'package:mr_blogger/models/comment.dart';

class Blogs {
  String uid, authorname, title, description, date, time, category;
  List<String> likes;
  List<String> image;
  List<Comment> comments;
  int timeStamp;
  bool blogPrivacy;
  bool isBookMarked;
  bool isFollowing;
  Blogs(
      {this.image,
      this.uid,
      this.authorname,
      this.title,
      this.description,
      this.date,
      this.likes,
      this.comments,
      this.category,
      this.time,
      this.timeStamp,
      this.blogPrivacy,
      this.isBookMarked,
      this.isFollowing})
      : super();

  factory Blogs.fromJson(Map<String, dynamic> parsedJson) {
    return Blogs(
        image: parsedJson['image'] ?? '',
        uid: parsedJson['uid'] ?? '',
        authorname: parsedJson['authorname'] ?? '',
        title: parsedJson['title'] ?? '',
        description: parsedJson['description'] ?? '',
        likes: parsedJson['likes'] ?? null,
        isFollowing: parsedJson['isFollowing'] ?? '',
        comments: parsedJson['comments'] ?? null,
        date: parsedJson['date'] ?? '',
        category: parsedJson['category'] ?? '',
        time: parsedJson['time'] ?? '',
        timeStamp: parsedJson['timeStamp'] ?? '',
        blogPrivacy: parsedJson['blogPrivacy'] ?? '',
        isBookMarked: parsedJson['isBookMarked'] ?? '');
  }
  Map<String, dynamic> toJson() => _dimensionsToJson(this);
}

Map<String, dynamic> _dimensionsToJson(Blogs blog) => <String, dynamic>{
      'image': blog.image,
      'uid': blog.uid,
      'authorname': blog.authorname,
      'title': blog.title,
      'description': blog.description,
      'likes': blog.likes,
      'comments': blog.comments,
      'isFollowing': blog.isFollowing,
      'date': blog.date,
      'time': blog.time,
      'category': blog.category,
      'timeStamp': blog.timeStamp,
      'blogPrivacy': blog.blogPrivacy
    };
