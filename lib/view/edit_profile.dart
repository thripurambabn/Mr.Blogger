import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/blog_detail_Screen.dart';
import 'package:mr_blogger/view/login_screen.dart';
import 'package:mr_blogger/view/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final Users user;
  final String name;
  final String email;
  final String imageUrl;

  const EditProfilePage(
      {Key key, this.user, this.name, this.email, this.imageUrl})
      : super(key: key);

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //instance of userService

  static BlogsService _blogsService = BlogsService();
  static ProfileService _profileService = ProfileService();
  SharedPreferences sharedPreferences;
  TextEditingController _nameController = TextEditingController();
  String email;
  File sampleImage;
  String imageUrl;
  var _profile =
      ProfileBloc(profileService: _profileService, blogsService: _blogsService);
  List<Blogs> blogsList = [];
  @override
  void initState() {
    //calls loaded profile details event

    _profile.add(
      LoadedProfileDeatils(),
    );
    print('details received by edit page ${widget.imageUrl} ${widget.name} ');
    _nameController.text = widget.name != null ? widget.name : '';
    super.initState();
  }

  void saveprofile() {
    print(
        'in edit profile ui----------------${_nameController.text} ${imageUrl},');
    var newUrl = imageUrl ?? widget.imageUrl;
    _profile.add(
      EditProfile(_nameController.text, newUrl),
    );
  }

  void navigateToProfilePage() {
    Timer(Duration(seconds: 8), () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return new ProfilePage();
        },
      ));
    });
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
                print('imageUrl near save profile${imageUrl}');
                saveprofile();
                navigateToProfilePage();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: <Widget>[
            Container(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                bloc: _profile,
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Image.network(
                        'https://i.pinimg.com/originals/1a/e0/90/1ae090fce667925b01954c2eb72308b6.gif');
                  } else if (state is ProfileLoaded) {
                    return profileUi(state.displayName, state.imageUrl);
                  } else if (state is ProfileNotLoaded) {
                    return errorUI();
                  }
                },
              ),
            ),
          ]),
        )));
  }

  Future getImage() async {
    print('selecting and image');
    final _picker = ImagePicker();
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 85);
    final File file = File(pickedFile.path);
    print('selected a image');
    setState(() {
      sampleImage = file;
    });
    var url =
        await _profileService.uploadProfileImage(sampleImage: sampleImage);
    print('image url');
    setState(() {
      imageUrl = url;
    });
    print('imageUrl $imageUrl');
  }

//user deatils widget
  Widget profileUi(String username, String imageUrl) {
    return new Column(children: <Widget>[
      Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 110.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            colors: [
                              Colors.purple[400],
                              Colors.purple[300],
                              Colors.purple[900]
                            ],
                            end: FractionalOffset.topCenter),
                        color: Colors.purpleAccent),
                  ),
                )
              ],
            ),
            Positioned(
                top: 30.0,
                child: InkWell(
                  onTap: () => {print('tapping'), getImage()},
                  child: Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.imageUrl ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG2_068DwPxMkNGtNretnitrJOBG4hJSeYGGyI9yfSaCvRA7Rj&usqp=CAU'),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 6.0)),
                  ),
                )),
          ],
        ),
      ),
      SizedBox(
        height: 70,
      ),
      Container(
        padding: EdgeInsets.all(15),
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            icon: Icon(
              Icons.person,
              color: Colors.purple[800],
            ),
            labelText: 'Username',
          ),
          autocorrect: false,
          autovalidate: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    ]);
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
              offset: Offset(8.0, 8.0),
            ),
          ],
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Paficico',
          color: Colors.purple),
    ));
  }
}
