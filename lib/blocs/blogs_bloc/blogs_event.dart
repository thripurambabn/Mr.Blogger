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
  final List<Blogs> blogslist;

  BlogsLoad(this.blogslist);
  @override
  String toString() => 'loadBlogs ';
  @override
  List<Object> get props => [blogslist];
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

class UploadBlog extends BlogsEvent {
  final File image;
  final String title, description, category;
  final bool blogPrivacy;
  final List<String> url;
  const UploadBlog({
    @required this.url,
    @required this.image,
    @required this.title,
    @required this.description,
    @required this.category,
    @required this.blogPrivacy,
  });
  @override
  List<Object> get props =>
      [image, url, title, description, category, blogPrivacy];

  @override
  String toString() => 'ImageBlog { blog: $image }';
}

class UpdateBlog extends BlogsEvent {
  final List<String> image;
  final bool blogPrivacy;
  final String url, title, description, category;
  int timeStamp;

  UpdateBlog(
      {this.image,
      this.url,
      this.title,
      this.description,
      this.category,
      this.timeStamp,
      this.blogPrivacy});
  @override
  List<Object> get props =>
      [image, url, title, description, category, timeStamp, blogPrivacy];

  @override
  String toString() => 'Updateblog { blog: $image }';
}

class DeleteBlog extends BlogsEvent {
  final String key;

  const DeleteBlog(this.key);
  @override
  List<Object> get props => [key];

  @override
  String toString() => 'Deleted blog { blog: $key }';
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

class FollowBlogs extends BlogsEvent {
  final bool isFollowing;
  final String uid;

  FollowBlogs(this.isFollowing, this.uid);
  @override
  List<Object> get props => [isFollowing, uid];

  @override
  String toString() => 'Updateblog { blog: $uid }';
}

class BookMark extends BlogsEvent {
  final bool isBookMarked;
  final Blogs blog;

  BookMark(this.isBookMarked, this.blog);
  @override
  List<Object> get props => [isBookMarked, blog];

  @override
  String toString() => 'Updateblog { blog: $blog }';
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

class EditComments extends BlogsEvent {
  final int blogsTimeStamp;
  final int commentTimeStamp;
  final String comment;

  EditComments(this.blogsTimeStamp, this.commentTimeStamp, this.comment);
  @override
  List<Object> get props => [blogsTimeStamp, commentTimeStamp, comment];

  @override
  String toString() => 'Updateblog { blog: $blogsTimeStamp,$commentTimeStamp }';
}
