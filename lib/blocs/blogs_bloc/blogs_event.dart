import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/home_screen.dart';

abstract class BlogsEvent extends Equatable {
  const BlogsEvent();
}

class BlogsLoad extends BlogsEvent {
  @override
  String toString() => 'loadBlogs ';
  @override
  List<Object> get props => [];
}

class FetchBlogs extends BlogsEvent {
  // final List<Blogs> blogslist;

  // const FetchBlogs(this.blogslist);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loadedblog';
}

class AddBlog extends BlogsEvent {
  final List<Blogs> blog;

  const AddBlog(this.blog);

  @override
  List<Object> get props => [blog];

  @override
  String toString() => 'AddBlog { blog: $blog }';
}

class UploadImage extends BlogsEvent {
  final File image;
  final String url, title, description, category;
  const UploadImage({
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

// class SaveToDatabaseEvent extends BlogsEvent {
//   final String imageurl, title, description;

//   const SaveToDatabaseEvent(this.description, this.imageurl, this.title);
//   @override
//   List<Object> get props => [imageurl, title, description];

//   @override
//   String toString() => 'savetodatabase event { blog: $imageurl }';
// }

class GetImage extends BlogsEvent {
  @override
  List<Object> get props => [];
}

//class SavingToDatabase extends BlogsEvent {}
