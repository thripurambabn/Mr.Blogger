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
    var tempLikes = [];
    var tempImages = [];
    var tempComments;
    var commentsList = new List<Comment>();
    var likesList = new List<String>();
    var imagesList = new List<String>();
    if (parsedJson['likes'] != null) {
      tempLikes = parsedJson['likes'];

      for (var like in tempLikes) {
        likesList.add(like.toString());
      }
    }
    if (parsedJson['image'] != null) {
      tempImages = parsedJson['image'];
      for (var image in tempImages) {
        if (image != null) {
          imagesList.add(image);
        }
      }
    }
    if (parsedJson['comments'] != null) {
      tempComments = parsedJson['comments'];
      for (var comment in tempComments) {
        if (comment != null) {
          var newComment = new Comment(
            username: comment['username'],
            date: comment['date'],
            comment: comment['comment'],
          );
          commentsList.add(newComment);
        }
      }
    }
    return Blogs(
      image: imagesList ?? '',
      uid: parsedJson['uid'] ?? '',
      authorname: parsedJson['authorname'] ?? '',
      title: parsedJson['title'] ?? '',
      description: parsedJson['description'] ?? '',
      likes: likesList ?? null,
      isFollowing: parsedJson['isFollowing'] ?? '',
      comments: commentsList ?? null,
      date: parsedJson['date'] ?? '',
      category: parsedJson['category'] ?? '',
      time: parsedJson['time'] ?? '',
      timeStamp: parsedJson['timeStamp'] ?? '',
      blogPrivacy: parsedJson['blogPrivacy'] ?? '',
      //  isBookMarked: parsedJson['isBookMarked'] ?? ''
    );
  }
  Map<String, dynamic> toJson() => toMap(this);
}

Map<String, dynamic> toMap(Blogs blog) => <String, dynamic>{
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
