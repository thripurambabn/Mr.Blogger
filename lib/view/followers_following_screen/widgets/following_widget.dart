import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/other_user_profile_bloc/other_user_profile_bloc.dart';
import 'package:mr_blogger/blocs/other_user_profile_bloc/other_user_profile_event.dart';
import 'package:mr_blogger/blocs/other_user_profile_bloc/other_user_profile_state.dart';
import 'package:mr_blogger/view/followers_following_screen/widgets/following_tile_widget.dart';

class FollowingWidget extends StatefulWidget {
  final String uid;
  final List<String> following;
  final Function(String) navigateToProfilePage;
  final String userName;
  const FollowingWidget(
      {Key key,
      this.following,
      this.userName,
      this.navigateToProfilePage,
      this.uid})
      : super(key: key);

  @override
  _FollowingWidgetState createState() => _FollowingWidgetState();
}

class _FollowingWidgetState extends State<FollowingWidget> {
  void initState() {
    //calls loaded profile details event
    BlocProvider.of<OtherUserProfileBloc>(context).add(
      OtherUserProfileEvent(widget.following),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherUserProfileBloc, OtherUserProfileState>(
      bloc: BlocProvider.of<OtherUserProfileBloc>(context),
      builder: (context, state) {
        if (state is OtherUserProfileLoading) {
          return Image.network(
              'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
        } else if (state is OtherUserProfileLoaded) {
          print('sate ${state.userData.uid}');
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, i) {
              return widget.following != null
                  ? FollowingTileWidget(
                      currentUid: state.userData.uid,
                      uid: widget.uid,
                      followingUser: state.users[i],
                      navigateToProfilePage: (value) {
                        widget.navigateToProfilePage(value);
                      },
                    )
                  : Container(child: Text('you have no followers yet'));
            },
          );
        } else if (state is OtherUserProfileNotLoaded) {
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
