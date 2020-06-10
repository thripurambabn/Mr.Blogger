import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/home_screen.dart';

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

class DeleteBlog extends BlogsEvent {
  final int key;
  const DeleteBlog(@required this.key);
  @override
  List<Object> get props => [key];

  @override
  String toString() => 'Deleted blog { blog: $key }';
}

class SearchBlog extends BlogsEvent {
  final String searchkey;

  SearchBlog(this.searchkey);

  @override
  List<Object> get props => [searchkey];

  @override
  String toString() => 'Serached blog { blog: $searchkey }';
}
