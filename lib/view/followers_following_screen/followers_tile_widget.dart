import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';

class FollowersTileWidget extends StatefulWidget {
  final String follower;
  const FollowersTileWidget({Key key, this.follower}) : super(key: key);

  @override
  _FollowersTileWidgetState createState() => _FollowersTileWidgetState();
}

class _FollowersTileWidgetState extends State<FollowersTileWidget> {
  void initState() {
    //calls loaded profile details event
    BlocProvider.of<ProfileBloc>(context).add(
      LoadedProfileDeatils(widget.follower),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: BlocProvider.of<ProfileBloc>(context),
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Image.network(
              'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
        } else if (state is ProfileLoaded) {
          print(
              'follow_tile_widget3 ${widget.follower}  ${state.displayName}  ${state.email}');
          return new ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(state.imageUrl ??
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG2_068DwPxMkNGtNretnitrJOBG4hJSeYGGyI9yfSaCvRA7Rj&usqp=CAU'),
              ),
              title: Text(state.displayName),
              //subtitle: Text(state.email),
              trailing: Container(
                height: 30,
                width: 83,
                child: new FlatButton(
                  onPressed: null,
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
  // ListView.builder(
  //   itemCount: widget.followers.length,
  //   itemBuilder: (context, i) {
  //     return widget.followers != null
  //         ? ListTile(
  //             title: Text(widget.followers[i]),
  //           )
  //         : Container(child: Text('you have no followers yet'));
  //   },
  // );
}
