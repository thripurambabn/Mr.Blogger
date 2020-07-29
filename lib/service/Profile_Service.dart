import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/comment.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/service/user_service.dart';

class ProfileService {
  var userService = UserService();
  List<Blogs> blogsList = [];
  var userData;

//To fetch blogs of logged in user
  Future getblogs() async {
    var userid = await userService.getUserID();
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    final DataSnapshot snapshot =
        await blogsref.orderByChild('uid').equalTo(userid).once();
    try {
      if (snapshot.value != null) {
        var refkey = snapshot.value.keys;
        var data = snapshot.value;

        for (var key in refkey) {
          var tempLikes = [];
          var tempImages = [];
          var tempfollowers = [];
          var tempComments;
          var commentsList = new List<Comment>();
          var likesList = new List<String>();
          var followersList = new List<String>();
          var imagesList = new List<String>();
          if (data[key]['likes'] != null) {
            tempLikes = data[key]['likes'];

            for (var like in tempLikes) {
              likesList.add(like.toString());
            }
          }
          if (data[key]['followers'] != null) {
            tempfollowers = data[key]['followers'];
            for (var follower in tempfollowers) {
              followersList.add(follower.toString());
            }
          }
          if (data[key]['image'] != null) {
            tempImages = data[key]['image'];
            for (var image in tempImages) {
              if (image != null) {
                imagesList.add(image);
              }
            }
          }
          if (data[key]['comments'] != null) {
            tempComments = data[key]['comments'];
            for (var comment in tempComments) {
              if (comment != null) {
                var newComment = new Comment(
                  username: comment['username'],
                  date: comment['date'],
                  comment: comment['comment'],
                );
                commentsList.add(newComment);
              }
            }
          }
          Blogs blog = new Blogs(
              image: imagesList,
              uid: data[key]['uid'],
              authorname: data[key]['authorname'],
              title: data[key]['title'],
              description: data[key]['description'],
              likes: likesList,
              comments: commentsList,
              followers: followersList,
              date: data[key]['date'],
              category: data[key]['category'],
              time: data[key]['time'],
              timeStamp: data[key]['timeStamp'],
              blogPrivacy: data[key]['blogPrivacy']);
          blogsList.clear();
          blogsList.add(blog);
        }
      } else {
        print('there are no blogs of this user');
      }
    } catch (e) {
      print(e);
    }
    return blogsList;
  }

  Future getProfileDetails(String uid) async {
    var currentuserid = await userService.getUserID();
    var userid = uid == null ? currentuserid : uid;
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('users');
    final DataSnapshot snapshot =
        await blogsref.orderByChild('uid').equalTo(userid).once();
    try {
      if (snapshot.value != null) {
        var data = snapshot.value;
        var mapData = new Map<String, dynamic>.from(data);
        var user = new Users.fromJson(mapData);
        userData = user;
        print('userdata in service${user.displayName}');
      } else {
        print('there are no blogs of this user');
      }
    } catch (e) {
      print(e);
    }
    return userData;
  }

//To delete a blog from firebase
  Future deleteBlog(String key) {
    FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('title')
        .equalTo(key)
        .onChildAdded
        .listen((Event event) {
      FirebaseDatabase.instance
          .reference()
          .child('blogs')
          .child(event.snapshot.key)
          .remove();
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

//To update a blog from firebase
  Future updateBlog(
      url, mytitlevalue, myvalue, category, blogtimeStamp, blogPrivacy) {
    try {
      var dbkey = new DateTime.now();
      var formatdate = new DateFormat('MMM d,yyyy');
      var formattime = new DateFormat('EEEE, hh:mm aaa');
      String date = formatdate.format(dbkey);
      String time = formattime.format(dbkey);

      var data = {
        'image': url,
        'category': category,
        'title': mytitlevalue,
        'description': myvalue,
        'date': date,
        'time': time,
      };
      FirebaseDatabase.instance
          .reference()
          .child('blogs')
          .orderByChild('timeStamp')
          .equalTo(blogtimeStamp)
          .onChildAdded
          .listen((Event event) {
        FirebaseDatabase.instance
            .reference()
            .child('blogs')
            .child(event.snapshot.key)
            .update(data);
      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
      });
    } catch (e) {
      print('e');
    }
  }

  Future<String> uploadProfileImage({
    sampleImage,
  }) async {
    String url;
    final StorageReference iamgeref =
        FirebaseStorage.instance.ref().child("Blog images");
    var timekey = new DateTime.now();

    final StorageUploadTask uploadImage =
        iamgeref.child(timekey.toString() + '.jpg').putFile(sampleImage);
    var imageurl = await uploadImage.onComplete;
    var imageurl1 = await imageurl.ref.getDownloadURL();
    url = imageurl1.toString();
    return url;
  }

  Future<void> updateImage(
      {sampleImage,
      mytitlevalue,
      myvalue,
      category,
      blogtimeStamp,
      blogPrivacy}) async {
    try {
      await updateBlog(sampleImage, mytitlevalue, myvalue, category,
          blogtimeStamp, blogPrivacy);
    } catch (e) {
      print(e.toString());
    }
  }

  Future editProfile(String name, String imageUrl) async {
    try {
      final FirebaseAuth firebaseAuth1 = FirebaseAuth.instance;
      final FirebaseUser user = await firebaseAuth1.currentUser();
      var addusername = UserUpdateInfo();

      addusername.displayName = name;
      addusername.photoUrl = imageUrl;
      await user.updateProfile(addusername);
      await user.reload();
      var data = {'username': name, 'photoUrl': imageUrl};
      var authordata = {
        'authorname': name,
      };
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .orderByChild('uid')
          .equalTo(user.uid)
          .onChildAdded
          .listen((Event event) {
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(event.snapshot.key)
            .update(data);
      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
      });
      FirebaseDatabase.instance
          .reference()
          .child('blogs')
          .orderByChild('uid')
          .equalTo(user.uid)
          .onChildAdded
          .listen((Event event) {
        FirebaseDatabase.instance
            .reference()
            .child('blogs')
            .child(event.snapshot.key)
            .update(authordata);
      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
      });
    } catch (e) {
      print('e');
    }
  }
}
