import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/comment.dart';

abstract class BlogsEvent extends Equatable {
  const BlogsEvent();
  @override
  List<Object> get props => [];
}

//blogs load event
class BlogsLoad extends BlogsEvent {
  @override
  String toString() => 'loadBlogs ';
  @override
  List<Object> get props => [];
}

//fetch blogs event
class FetchBlogs extends BlogsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loadedblog';
}

// add new blog event
class AddBlog extends BlogsEvent {
  final Blogs blog;

  const AddBlog(this.blog);

  @override
  List<Object> get props => [blog];

  @override
  String toString() => 'AddBlog { blog: $blog }';
}

//Upload image event
// class UploadImage extends BlogsEvent {
//   final File image;
//   final String url;
//   const UploadImage({
//     @required this.url,
//     @required this.image,
//   });
//   @override
//   List<Object> get props => [image, url];

//   @override
//   String toString() => 'ImageBlog { blog: $image }';
// }

class UploadBlog extends BlogsEvent {
  final File image;
  final String url, title, description, category;
  const UploadBlog({
    @required this.url,
    @required this.image,
    @required this.title,
    @required this.description,
    @required this.category,
  });
  @override
  List<Object> get props => [image, url, title, description, category];

  @override
  String toString() => 'ImageBlog { blog: $image }';
}

class SearchBlog extends BlogsEvent {
  final String searchkey;

  SearchBlog(this.searchkey);

  @override
  List<Object> get props => [searchkey];

  @override
  String toString() => 'Serached blog { blog: $searchkey }';
}

class UpdateBlog extends BlogsEvent {
  final String image;
  final String url, title, description, category;
  int timeStamp;

  UpdateBlog({
    this.image,
    this.url,
    this.title,
    this.description,
    this.category,
    this.timeStamp,
  });
  @override
  List<Object> get props =>
      [image, url, title, description, category, timeStamp];

  @override
  String toString() => 'Updateblog { blog: $image }';
}

class BlogLikes extends BlogsEvent {
  final int timeStamp;
  final List<String> likes;

  BlogLikes(this.timeStamp, this.likes);
  @override
  List<Object> get props => [timeStamp, likes];

  @override
  String toString() => 'Updateblog { blog: $timeStamp }';
}

class BlogComments extends BlogsEvent {
  final int timeStamp;
  final String comment;
  final List<Comment> comments;
  final String uid;

  BlogComments(this.timeStamp, this.comment, this.comments, this.uid);
  @override
  List<Object> get props => [timeStamp, comment, comments, uid];

  @override
  String toString() => 'Updateblog { blog: $timeStamp }';
}

class DeleteComments extends BlogsEvent {
  final int blogsTimeStamp;
  final int commentTimeStamp;

  DeleteComments(this.blogsTimeStamp, this.commentTimeStamp);
  @override
  List<Object> get props => [blogsTimeStamp, commentTimeStamp];

  @override
  String toString() => 'Updateblog { blog: $blogsTimeStamp,$commentTimeStamp }';
}
