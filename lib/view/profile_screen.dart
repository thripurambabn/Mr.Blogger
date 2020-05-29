import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Users> userlist = [];
  var userService = UserService();
  Future _userdata;
  Future _data;
  List<Blogs> blogsList = [];
  @override
  void initState() {
    _userdata = getUserdata();
    _data = getblogs();
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

  Future getblogs() async {
    var userid = await userService.getUser();
    print('userdata in profile----- ${userid}');
    var username = await userService.getUserName();
    print('username in profile----- ${username}');
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    blogsref
        .orderByChild('uid')
        .equalTo(userid)
        .once()
        .then((DataSnapshot snapshot) {
      var refkey = snapshot.value.keys;
      var data = snapshot.value;
      blogsList.clear();
      for (var key in refkey) {
        Blogs blog = new Blogs(
            data[key]['image'],
            data[key]['uid'],
            data[key]['authorname'],
            data[key]['title'],
            data[key]['description'],
            data[key]['date'],
            data[key]['likes'],
            data[key]['time']);
        blogsList.add(blog);
      }
      setState(() {
        print('total number of blogs in profile ${blogsList.length}');
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
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: <Widget>[
            profileUi(userlist[0].username, userlist[0].email),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Blogs',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    // fontFamily: 'Paficico',
                    color: Colors.purple),
                textAlign: TextAlign.left,
              ),
            ),
            Divider(
              height: 10,
              thickness: 5,
              color: Colors.purple,
            ),
            InkWell(
              child: Container(
                child: FutureBuilder(
                  future: _data,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print('loading');
                      return Center(
                        child: Image.network(
                            'https://i.pinimg.com/originals/2c/bb/5e/2cbb5e95b97aa2b496f6eaec84b9240d.gif'),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Expanded(
                          child: SizedBox(
                            child: new ListView.builder(
                                shrinkWrap: true,
                                itemCount: blogsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print('${blogsList[index].title}');
                                  return ListTile(
                                    title: blogsUi(
                                        blogsList[index].image,
                                        blogsList[index].uid,
                                        blogsList[index].authorname,
                                        blogsList[index].title,
                                        blogsList[index].description,
                                        blogsList[index].likes,
                                        blogsList[index].date,
                                        blogsList[index].time),
                                  );
                                }),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ]),
        )));
  }

  Widget blogsUi(String image, String uid, String authorname, String title,
      String description, String likes, String date, String time) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title.substring(0, 9) + '....',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Paficico',
                      color: Colors.purple),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Image.network(
              image,
              fit: BoxFit.cover,
              height: 300,
              width: 350,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Container(
                        color: Colors.purple[50],
                        height: 300,
                        width: 350,
                      );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'By: ' + authorname,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.right,
                  ),
                  new Text(
                    date,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[350],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ]),
            SizedBox(
              height: 10,
            ),
            Container(
              child: new Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget profileUi(String username, String email) {
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
  ]);
}

class Users {
  String username, email;
  Users(this.username, this.email);
}
