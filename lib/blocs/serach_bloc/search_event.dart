import 'package:equatable/equatable.dart';

abstract class SearchBlogsEvent extends Equatable {
  const SearchBlogsEvent();
  @override
  List<Object> get props => [];
}

class SearchBlog extends SearchBlogsEvent {
  final String searchkey;

  SearchBlog(this.searchkey);

  @override
  List<Object> get props => [searchkey];

  @override
  String toString() => 'Serached blog { blog: $searchkey }';
}
