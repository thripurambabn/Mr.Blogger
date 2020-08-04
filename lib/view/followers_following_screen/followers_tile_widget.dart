import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';

class FollowersTileWidget extends StatefulWidget {
  final String currentUid;
  final String uid;
  final followerUser;
  final Function(String) navigateToProfilePage;
  const FollowersTileWidget(
      {Key key,
      this.followerUser,
      this.navigateToProfilePage,
      this.uid,
      this.currentUid})
      : super(key: key);

  @override
  _FollowersTileWidgetState createState() => _FollowersTileWidgetState();
}

class _FollowersTileWidgetState extends State<FollowersTileWidget> {
  @override
  Widget build(BuildContext context) {
    void setfollow(
      bool isFollowing,
      String uid,
    ) {
      BlocProvider.of<BlogsBloc>(context).add(FollowBlogs(isFollowing, uid));
    }

    return new ListTile(
        onTap: () {
          widget.navigateToProfilePage(widget.followerUser.uid);
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.followerUser.imageUrl),
        ),
        title: Text(widget.followerUser.displayName),
        trailing: (widget.uid == widget.currentUid)
            ? Container(
                height: 30,
                width: 90,
                child: new FlatButton(
                  onPressed: () {
                    setfollow(false, widget.followerUser.uid);
                  },
                  child: Text('Remove',
                      style: TextStyle(color: Colors.purple[500])),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.purple[400], style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5)),
                ),
              )
            : SizedBox());
  }
}
