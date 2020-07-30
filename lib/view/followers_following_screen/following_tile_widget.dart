import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';

class FollowingTileWidget extends StatefulWidget {
  final String following;
  final Function navigateToProfilePage;
  const FollowingTileWidget(
      {Key key, this.following, this.navigateToProfilePage})
      : super(key: key);

  @override
  _FollowingTileWidgetState createState() => _FollowingTileWidgetState();
}

class _FollowingTileWidgetState extends State<FollowingTileWidget> {
  void initState() {
    //calls loaded profile details event
    BlocProvider.of<ProfileBloc>(context).add(
      LoadedProfileDeatils(widget.following),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void setfollow(
      bool isFollowing,
      String uid,
    ) {
      BlocProvider.of<BlogsBloc>(context).add(FollowBlogs(isFollowing, uid));
    }

    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: BlocProvider.of<ProfileBloc>(context),
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Image.network(
              'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
        } else if (state is ProfileLoaded) {
          print('profile details ${state.displayName}');
          var imageUrl = state.imageUrl.isEmpty
              ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG2_068DwPxMkNGtNretnitrJOBG4hJSeYGGyI9yfSaCvRA7Rj&usqp=CAU'
              : state.imageUrl;
          return new ListTile(
              onTap: widget.navigateToProfilePage,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              title: Text(state.displayName),
              trailing: Container(
                height: 30,
                width: 90,
                child: new FlatButton(
                  onPressed: () {
                    setfollow(false, state.uid);
                  },
                  child: Text('Unfollow',
                      style: TextStyle(color: Colors.purple[500])),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.purple[400], style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ));
        } else if (state is ProfileNotLoaded) {
          return Text(
            'Something went wrong please try again later',
            textAlign: TextAlign.center,
            style: TextStyle(
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.purple[200],
                    offset: Offset(8.0, 8.0),
                  ),
                ],
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Paficico',
                color: Colors.purple),
          );
        }
      },
    );
  }
}
