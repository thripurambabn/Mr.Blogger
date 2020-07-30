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
  final String uid;
  const LoadedProfileDeatils(this.uid);
  @override
  List<Object> get props => [uid];
  @override
  String toString() => 'Loadedprofile';
}

class RemoveFollow extends ProfileEvent {
  final List<String> followers;

  RemoveFollow(
    this.followers,
  );
  @override
  List<Object> get props => [
        followers,
      ];

  @override
  String toString() => 'Updateblog { blog: }';
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
