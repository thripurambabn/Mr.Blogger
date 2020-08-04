import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';

class FollowingTileWidget extends StatefulWidget {
  final followingUser;
  final Function(String) navigateToProfilePage;
  const FollowingTileWidget(
      {Key key, this.followingUser, this.navigateToProfilePage})
      : super(key: key);

  @override
  _FollowingTileWidgetState createState() => _FollowingTileWidgetState();
}

class _FollowingTileWidgetState extends State<FollowingTileWidget> {
  @override
  Widget build(BuildContext context) {
    void setfollow(
      bool isFollowing,
      String uid,
    ) {
      BlocProvider.of<BlogsBloc>(context).add(FollowBlogs(isFollowing, uid));
    }

    print('widget.user ${widget.followingUser.displayName}');
    return new ListTile(
        onTap: () {
          widget.navigateToProfilePage(widget.followingUser.uid);
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.followingUser.imageUrl),
        ),
        title: Text(widget.followingUser.displayName),
        trailing: Container(
          height: 30,
          width: 90,
          child: new FlatButton(
            onPressed: () {
              setfollow(false, widget.followingUser..uid);
            },
            child:
                Text('Unfollow', style: TextStyle(color: Colors.purple[500])),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.purple[400], style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5)),
          ),
        ));
  }
}
