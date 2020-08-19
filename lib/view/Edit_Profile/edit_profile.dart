import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mr_blogger/Internetconnectivity.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/view/Edit_Profile/edit_profile_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final Users user;
  final String uid;
  final String name;
  final String email;
  final String imageUrl;

  const EditProfilePage(
      {Key key, this.user, this.name, this.email, this.imageUrl, this.uid})
      : super(key: key);

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static ProfileService _profileService = ProfileService();
  SharedPreferences sharedPreferences;
  TextEditingController _nameController = TextEditingController();
  String email;
  File sampleImage;
  String imageUrl;
  List<Blogs> blogsList = [];
  @override
  void initState() {
    //calls loaded profile details event

    BlocProvider.of<ProfileBloc>(context).add(
      LoadedProfileDeatils(widget.uid),
    );
    _nameController.text = widget.name != null ? widget.name : '';
    super.initState();
  }

  void saveprofile() {
    var newUrl = imageUrl ?? widget.imageUrl;
    BlocProvider.of<ProfileBloc>(context).add(
      EditProfile(_nameController.text, newUrl),
    );
  }

  void navigateToProfilePage() {
    Navigator.pop(context);
  }

  Widget build(BuildContext ctx) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.save),
              onPressed: () {
                saveprofile();
                navigateToProfilePage();
              },
            ),
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                return InternetConnectivity(
                  child: child,
                  connected: connected,
                );
              },
              child: SingleChildScrollView(
                  child: Container(
                child: Column(children: <Widget>[
                  Container(
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      bloc: BlocProvider.of<ProfileBloc>(context),
                      builder: (context, state) {
                        if (state is ProfileLoading) {
                          return Image.network(
                              'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                        } else if (state is ProfileLoaded) {
                          return EditProfileUI(
                            nameController: _nameController,
                            imageUrl: state.imageUrl,
                            getImage: () {
                              getImage();
                            },
                          );
                        } else if (state is ProfileNotLoaded) {
                          return errorUI();
                        }
                      },
                    ),
                  ),
                ]),
              )));
        }));
  }

  Future getImage() async {
    final _picker = ImagePicker();
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 85);
    final File file = File(pickedFile.path);

    setState(() {
      sampleImage = file;
    });
    var url =
        await _profileService.uploadProfileImage(sampleImage: sampleImage);

    setState(() {
      imageUrl = url;
    });
  }

  Widget errorUI() {
    return new Center(
        child: Text(
      'Couldnt load your info..please try again later',
      textAlign: TextAlign.center,
      style: TextStyle(
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.purple[200],
              offset: Offset(3.0, 3.0),
            ),
          ],
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Paficico',
          color: Colors.purple),
    ));
  }
}
