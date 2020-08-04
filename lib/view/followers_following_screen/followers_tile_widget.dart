import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';

class FollowerTileWidget extends StatefulWidget {
  final String follower;
  final Function navigateToProfilePage;
  const FollowerTileWidget({Key key, this.follower, this.navigateToProfilePage})
      : super(key: key);

  @override
  _FollowerTileWidgetState createState() => _FollowerTileWidgetState();
}

class _FollowerTileWidgetState extends State<FollowerTileWidget> {
  void initState() {
    //calls loaded profile details event
    BlocProvider.of<ProfileBloc>(context).add(
      LoadedProfileDeatils(widget.follower),
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
                width: 83,
                child: new FlatButton(
                  onPressed: () {
                    setfollow(false, state.uid);
                  },
                  child: Text('Remove',
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
