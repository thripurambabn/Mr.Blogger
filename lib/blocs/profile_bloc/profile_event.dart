import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

//Loading Profile Details event
class LoadingProfileDetails extends ProfileEvent {
  @override
  String toString() => 'loadprofile ';
}

//Loaded Profile Deatils event
class LoadedProfileDeatils extends ProfileEvent {
  const LoadedProfileDeatils();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Loadedprofile';
}

class EditProfile extends ProfileEvent {
  final String name;
  final String imageUrl;

  EditProfile(this.name, this.imageUrl);
  @override
  List<Object> get props => [name, imageUrl];

  @override
  String toString() => 'Deleted blog { blog: $name }';
}
