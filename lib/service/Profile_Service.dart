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
  var userData;
  bool isFollowing;
  bool isBookMarked;
//To fetch blogs of logged in user
  Future getblogs(String uid) async {
    List<Blogs> blogsList = [];
    var userid = await userService.getUserID();
    var currentUserid = uid == null ? userid : uid;
    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    final DataSnapshot snapshot =
        await blogsref.orderByChild('uid').equalTo(currentUserid).once();
    try {
      if (snapshot.value != null) {
        var refkey = snapshot.value.keys;
        var data = snapshot.value;

        for (var key in refkey) {
          var tempLikes = [];
          var tempImages = [];
          var tempfollowing = [];
          var tempComments;
          var commentsList = new List<Comment>();
          var likesList = new List<String>();
          var followingList = new List<String>();
          var imagesList = new List<String>();
          if (data[key]['likes'] != null) {
            tempLikes = data[key]['likes'];

            for (var like in tempLikes) {
              likesList.add(like.toString());
            }
          }
          var userid = await userService.getUserID();
          DatabaseReference usersRef =
              FirebaseDatabase.instance.reference().child('users');
          final DataSnapshot snapshot =
              await usersRef.orderByChild('uid').equalTo(userid).once();
          try {
            if (snapshot.value != null) {
              var refkey1 = snapshot.value.keys;
              var data1 = snapshot.value;
              for (var key in refkey1) {
                if (data1[key]['following'] != null) {
                  tempfollowing = data1[key]['following'];
                  for (var following in tempfollowing) {
                    followingList.add(following.toString());
                  }
                }
              }
            }
          } catch (e) {
            print(e);
          }
          isFollowing = followingList.contains(data[key]['uid']);
          if (data[key]['image'] != null) {
            tempImages = data[key]['image'];
            for (var image in tempImages) {
              if (image != null) {
                imagesList.add(image);
              }
            }
          }
          var tempBookMark = [];
          var bookMarkedList = List<String>();
          if (data[key]['bookMarks'] != null) {
            tempBookMark = data[key]['bookMarks'];
            for (var bookMark in tempBookMark) {
              bookMarkedList.add(bookMark.toString());
            }
          }
          isBookMarked = bookMarkedList.contains(key);

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
              isFollowing: isFollowing,
              isBookMarked: isBookMarked,
              image: imagesList,
              uid: data[key]['uid'],
              authorname: data[key]['authorname'],
              title: data[key]['title'],
              description: data[key]['description'],
              likes: likesList,
              comments: commentsList,
              date: data[key]['date'],
              category: data[key]['category'],
              time: data[key]['time'],
              timeStamp: data[key]['timeStamp'],
              blogPrivacy: data[key]['blogPrivacy']);

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
    var userid = await userService.getUserID();
    var currentUserid = uid == null ? userid : uid;
    DatabaseReference userref =
        FirebaseDatabase.instance.reference().child('users');
    final DataSnapshot snapshot =
        await userref.orderByChild('uid').equalTo(currentUserid).once();
    try {
      if (snapshot.value != null) {
        var refkey = snapshot.value.keys;
        var data = snapshot.value;

        for (var key in refkey) {
          var tempfollowing = [];
          var followingList = List<String>();
          if (data[key]['following'] != null) {
            tempfollowing = data[key]['following'];
            for (var following in tempfollowing) {
              if (following != null) followingList.add(following.toString());
            }
          }
          var tempBookMarks = [];
          var bookMarkedList = List<String>();
          if (data[key]['bookMarks'] != null) {
            tempBookMarks = data[key]['bookMarks'];
            for (var bookMark in tempBookMarks) {
              if (tempBookMarks != null) bookMarkedList.add(bookMark);
            }
          }
          var tempfollowers = [];
          var followersList = List<String>();
          if (data[key]['followers'] != null) {
            tempfollowers = data[key]['followers'];
            for (var followers in tempfollowers) {
              followersList.add(followers.toString());
            }
          }
          Users user = new Users(
              uid: data[key]['uid'],
              displayName: data[key]['username'],
              email: data[key]['email'],
              imageUrl: data[key]['photoUrl'],
              followers: followersList,
              following: followingList);
          userData = user;
        }
      } else {
        print('there are no blogs of this user');
      }
    } catch (e) {
      print(e);
    }
    return userData;
  }

  Future getBookMarkedDetails() async {
    var bookMarksList = List<String>();
    var bookMarksData = List<Blogs>();
    var tempfollowing = [];
    var followingList = List<String>();
    var userid = await userService.getUserID();
    final userRef = FirebaseDatabase.instance.reference().child('users');
    final DataSnapshot snapshot =
        await userRef.orderByChild('uid').equalTo(userid).once();
    var refkey = snapshot.value.keys;
    var data = snapshot.value;
    for (var key in refkey) {
      var tempBookMarks = [];
      if (data[key]['bookMarks'] != null) {
        tempBookMarks = data[key]['bookMarks'];
        for (var bookMark in tempBookMarks) {
          if (tempBookMarks != null) bookMarksList.add(bookMark);
        }
      }

      if (data[key]['following'] != null) {
        tempfollowing = data[key]['following'];
        for (var following in tempfollowing) {
          if (following != null) followingList.add(following.toString());
        }
      }
    }

    for (var book in bookMarksList) {
      DatabaseReference blogsref =
          FirebaseDatabase.instance.reference().child('blogs');
      final DataSnapshot snapshot = await blogsref.once();
      var refKey = snapshot.value.keys;
      for (var key in refKey) {
        if (key == book) {
          DatabaseReference bookMarkref =
              FirebaseDatabase.instance.reference().child('blogs');
          final DataSnapshot snapshot1 = await bookMarkref.child(key).once();
          var tempImages = [];
          var bookMarkValue = snapshot1.value;
          var tempLikes = [];
          var likesList = List<String>();

          if (bookMarkValue['likes'] != null) {
            tempLikes = bookMarkValue['likes'];
            for (var like in tempLikes) {
              likesList.add(like.toString());
            }
          }

          var imagesList = new List<String>();
          if (bookMarkValue['image'] != null) {
            tempImages = bookMarkValue['image'];
            for (var image in tempImages) {
              if (image != null) {
                imagesList.add(image);
              }
            }
          }

          var tempComments;
          var commentsList = new List<Comment>();
          if (bookMarkValue['comments'] != null) {
            tempComments = bookMarkValue['comments'];
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

          isBookMarked = bookMarksList.contains(key);
          isFollowing = followingList.contains(bookMarkValue['uid']);
          Blogs bookMakrkedBlog = new Blogs(
              isBookMarked: isBookMarked,
              image: imagesList,
              uid: bookMarkValue['uid'],
              authorname: bookMarkValue['authorname'],
              title: bookMarkValue['title'],
              description: bookMarkValue['description'],
              likes: likesList,
              comments: commentsList,
              isFollowing: isFollowing,
              date: bookMarkValue['date'],
              time: bookMarkValue['time'],
              category: bookMarkValue['category'],
              timeStamp: bookMarkValue['timeStamp'],
              blogPrivacy: bookMarkValue['blogPrivacy']);
          bookMarksData.add(bookMakrkedBlog);
        }
      }
    }
    return bookMarksData;
  }

  Future getFollowersProfileDetails(List<String> uids) async {
    var followData = [];
    for (var uid in uids) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users');
      final DataSnapshot snapshot =
          await userRef.orderByChild('uid').equalTo(uid).once();
      try {
        if (snapshot.value != null) {
          var refkey = snapshot.value.keys;
          var data = snapshot.value;

          for (var key in refkey) {
            var tempfollowing = [];
            var followingList = List<String>();
            if (data[key]['following'] != null) {
              tempfollowing = data[key]['following'];
              for (var following in tempfollowing) {
                followingList.add(following.toString());
              }
            }
            var tempfollowers = [];
            var followersList = List<String>();
            if (data[key]['followers'] != null) {
              tempfollowers = data[key]['followers'];
              for (var followers in tempfollowers) {
                followersList.add(followers.toString());
              }
            }
            Users user = new Users(
                uid: data[key]['uid'],
                displayName: data[key]['username'],
                email: data[key]['email'],
                imageUrl: data[key]['photoUrl'],
                followers: followersList,
                following: followingList);
            followData.add(user);
          }
        } else {
          print('there are no blogs of this user');
        }
      } catch (e) {
        print(e);
      }
    }

    return followData;
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
