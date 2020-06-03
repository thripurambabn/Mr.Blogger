import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mr_blogger/view/home_screen.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileDetails extends ProfileEvent {
  @override
  String toString() => 'loadBlogs ';
}

class LoadedProfileDeatils extends ProfileEvent {
  const LoadedProfileDeatils();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loadedblog';
}

class ProfileLoadedBlog extends ProfileEvent {
  final List<Blogs> blogslist;

  const ProfileLoadedBlog(this.blogslist);

  @override
  List<Object> get props => [blogslist];

  @override
  String toString() => 'Loadedblog { blog: $blogslist }';
}
