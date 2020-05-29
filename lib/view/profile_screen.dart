import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/service/user_service.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Users> userlist = [];
  var userService = UserService();
  Future _userdata;

  @override
  void initState() {
    _userdata = getUserdata();
    print('userdata in init state ${_userdata}');
    super.initState();
  }

  Future getUserdata() async {
    var userid = await userService.getUser();
    print('userdata----- ${userid}');
    DatabaseReference userref =
        FirebaseDatabase.instance.reference().child('users');
    userref
        .orderByChild('uid')
        .equalTo(userid)
        .once()
        .then((DataSnapshot snapshot) {
      print('snapshot in userprofile values---${snapshot.value}');
      print('snapshot in userprofile keys---${snapshot.key}');
      var refkey = snapshot.value.keys;
      var data = snapshot.value;
      userlist.clear();
      for (var key in refkey) {
        Users user = new Users(
          data[key]['username'],
          data[key]['email'],
        );
        userlist.add(user);
        print('user ------${userlist[0].email},${userlist[0].username}');
      }
      setState(() {
        print('total number of users ${userlist.length}');
      });
    });
  }

  Widget build(BuildContext cx) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
          ),
        ),
        body: profileUi(userlist[0].username, userlist[0].email));
  }

  Widget profileUi(String username, String email) {
    return new ListView(children: <Widget>[
      new Column(children: <Widget>[
        Container(
          child: Stack(
            alignment: Alignment.bottomCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 150.0,
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
                top: 45.0,
                child: Container(
                  height: 190.0,
                  width: 190.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG2_068DwPxMkNGtNretnitrJOBG4hJSeYGGyI9yfSaCvRA7Rj&usqp=CAU'),
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 6.0)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
        ),
        Text(
          username,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        Text(
          email,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        )
      ])
    ]);
  }
}

class Users {
  String username, email;
  Users(this.username, this.email);
}
