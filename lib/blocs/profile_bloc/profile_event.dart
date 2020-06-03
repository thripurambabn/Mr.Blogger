import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadingProfileDetails extends ProfileEvent {
  @override
  String toString() => 'loadprofile ';
}

class LoadedProfileDeatils extends ProfileEvent {
  const LoadedProfileDeatils();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loadedprofile';
}
