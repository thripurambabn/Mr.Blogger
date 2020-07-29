import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/comment.dart';
import 'package:mr_blogger/service/user_service.dart';

class BlogsService {
  var userService = UserService();
  List<Blogs> blogsList = [];
  int value = 2;

//To fetch first set of blogs from the firebase database
  Future<List<Blogs>> getblogs() async {
    List<Blogs> blogsList = [];
    Query blogsref = FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('timeStamp')
        .limitToFirst(value);
    final DataSnapshot snapshot = await blogsref.once();
    var refkey = snapshot.value.keys;
    var data = snapshot.value;
    for (var key in refkey) {
      var tempLikes = [];
      var tempImages = [];
      var tempfollowers = [];
      var tempfollowing = [];
      var tempComments;
      var commentsList = new List<Comment>();
      var likesList = new List<String>();
      var followersList = new List<String>();
      var followingList = new List<String>();
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
      print('${data[key]['followers']} ${followersList}');
      if (data[key]['following'] != null) {
        tempfollowing = data[key]['following'];
        for (var follower in tempfollowing) {
          followingList.add(follower.toString());
        }
      }
      print('${data[key]['following']} ${followingList}');
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
          following: followingList,
          date: data[key]['date'],
          category: data[key]['category'],
          time: data[key]['time'],
          timeStamp: data[key]['timeStamp'],
          blogPrivacy: data[key]['blogPrivacy']);
      blogsList.add(blog);
    }
    //sort blogs on timestamp
    blogsList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    return blogsList;
  }

//To fetch more blogs from the firebase database on scroll(pagination)
  Future<List<Blogs>> getMoreBlogs(List<Blogs> blogs) async {
    List<Blogs> blogsList = [];

    var queryTimeStamp = blogs[blogs.length - 1].timeStamp;
    Query blogsref = FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('timeStamp')
        .startAt(queryTimeStamp + 1)
        .limitToFirst(value);
    final DataSnapshot snapshot = await blogsref.once();
    try {
      if (snapshot.value != null) {
        var refkey = snapshot.value.keys;
        var data = snapshot.value;

        for (var key in refkey) {
          var tempLikes = [];
          var tempfollowers = [];
          var likesList = new List<String>();
          var followersList = new List<String>();
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
          var tempComments;
          var commentsList = new List<Comment>();
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
          var tempImages = [];
          var imagesList = new List<String>();
          if (data[key]['image'] != null) {
            tempImages = data[key]['image'];

            for (var image in tempImages) {
              if (image != null) {
                imagesList.add(image);
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
              time: data[key]['time'],
              category: data[key]['category'],
              timeStamp: data[key]['timeStamp'],
              blogPrivacy: data[key]['blogPrivacy']);
          blogsList.clear();
          blogsList.add(blog);
        }
      }
    } catch (e) {
      print(e);
    }
    //sort blogs on timestamp
    blogsList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

    return blogsList;
  }

//To add new blog to the firebase database
  Future<void> saveToDatabase(List<String> url, String _mytitlevalue,
      String _myvalue, String category, bool blogPrivacy) async {
    try {
      //  var url = uploadImage();
      List<String> likes = [];
      List<String> comments = [];
      var dbkey = new DateTime.now();
      var formatdate = new DateFormat('MMM d,yyyy');
      var formattime = new DateFormat('EEEE, hh:mm aaa');
      String date = formatdate.format(dbkey);
      String time = formattime.format(dbkey);
      var userid = await userService.getUserID();
      var username = await userService.getUserName();
      var timeStamp = new DateTime.now().millisecondsSinceEpoch;
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      var data = {
        'image': url,
        'uid': userid,
        'authorname': username,
        'title': _mytitlevalue,
        'description': _myvalue,
        'likes': likes,
        'comments': comments,
        'category': category,
        'date': date,
        'time': time,
        'timeStamp': timeStamp,
        'blogPrivacy': blogPrivacy
      };
      databaseReference.child('blogs').push().set(data);
    } catch (e) {
      print('error in saving db ${e.toString()}');
    }
  }

//To Upload image to the firebase storage
  Future<String> uploadImage({
    sampleImage,
  }) async {
    String url;
    // if (validateandSave()) {
    ByteData byteData = await sampleImage.requestOriginal(quality: 50);
    List<int> imageData = byteData.buffer.asUint8List();
    var timekey = new DateTime.now();
    final StorageReference iamgeref = FirebaseStorage.instance
        .ref()
        .child("Blog images")
        .child(timekey.toString() + '.jpg');
    final StorageUploadTask uploadImage = iamgeref.putData(imageData);
    var imageurl = await uploadImage.onComplete;
    var imageurl1 = await imageurl.ref.getDownloadURL();
    url = imageurl1.toString();
    List<String> urlList = List<String>();
    urlList.add(url);
    return url;
  }

//To Search a blog in firebase
  Future searchBlogs(String searchKey) async {
    Query blogsref = FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('title')
        .startAt(searchKey)
        .endAt(searchKey + '\uf8ff');
    final DataSnapshot snapshot = await blogsref.once();

    try {
      if (snapshot.value != null) {
        var refkey = snapshot.value.keys;
        var data = snapshot.value;
        for (var key in refkey) {
          var tempLikes = [];
          var likesList = new List<String>();
          if (data[key]['likes'] != null) {
            tempLikes = data[key]['likes'];
            for (var like in tempLikes) {
              likesList.add(like.toString());
            }
          }
          var tempComments;
          var commentsList = new List<Comment>();
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
          var tempImages = [];
          var imagesList = new List<String>();
          if (data[key]['image'] != null) {
            tempImages = data[key]['image'];

            for (var image in tempImages) {
              if (image != null) {
                imagesList.add(image);
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
              date: data[key]['date'],
              time: data[key]['time'],
              category: data[key]['category'],
              timeStamp: data[key]['timeStamp'],
              blogPrivacy: data[key]['blogPrivacy']);

          blogsList.clear();
          blogsList.add(blog);
        }
      }
    } catch (e) {
      print(e);
    }
    return blogsList;
  }

  Future setLikes(int blogtimeStamp, var uid, List<String> likes) async {
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
          .update({'likes': likes});
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  Future setFollow(int blogtimeStamp, var uid, List<String> following,
      List<String> followers) async {
    var newfollowers = following ?? List<String>();
    var userid = await userService.getUserID();
    newfollowers.add(userid);
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .orderByChild('uid')
        .equalTo(uid)
        .onChildAdded
        .listen((Event event) {
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(event.snapshot.key)
          .update({'following': followers});
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
    FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('timeStamp')
        .equalTo(blogtimeStamp)
        .onChildAdded
        .listen((Event event) {
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .orderByChild('uid')
          .equalTo(event.snapshot.value['uid'])
          .onChildAdded
          .listen((Event event) {
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(event.snapshot.key)
            .update({'followers': newfollowers});
      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
      });
    });
  }

  convertToCommentJson(List<Comment> listOfComments) {
    List<Object> commentListObj = new List<Object>();
    for (Comment c in listOfComments) {
      commentListObj.add(c.toJson());
    }
    return commentListObj;
  }

  Future setComments(int blogtimeStamp, String comment, var uid,
      List<Comment> comments) async {
    var commentsData = comments;
    var timeStamp = new DateTime.now().millisecondsSinceEpoch;
    var username = await userService.getUserName();
    Comment commentobj = new Comment(
      username: username,
      date: timeStamp,
      comment: comment,
    );
    commentsData.add(commentobj);
    List<Object> convertedComments = convertToCommentJson(commentsData);
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
          .update({'comments': convertedComments});
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  Future deleteComments(
    int blogsTimeStamp,
    int commentTimeStamp,
  ) async {
    FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('timeStamp')
        .equalTo(blogsTimeStamp)
        .onChildAdded
        .listen((Event event) {
      FirebaseDatabase.instance
          .reference()
          .child('blogs')
          .child(event.snapshot.key)
          .child('comments')
          .orderByChild('date')
          .equalTo(commentTimeStamp)
          .onChildAdded
          .listen((commentEvent) {
        FirebaseDatabase.instance
            .reference()
            .child('blogs')
            .child(event.snapshot.key)
            .child('comments')
            .child(commentEvent.snapshot.key)
            .remove();
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  Future editComments(
      int blogsTimeStamp, int commentTimeStamp, String comment) async {
    FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('timeStamp')
        .equalTo(blogsTimeStamp)
        .onChildAdded
        .listen((Event event) {
      FirebaseDatabase.instance
          .reference()
          .child('blogs')
          .child(event.snapshot.key)
          .child('comments')
          .orderByChild('date')
          .equalTo(commentTimeStamp)
          .onChildAdded
          .listen((commentEvent) {
        FirebaseDatabase.instance
            .reference()
            .child('blogs')
            .child(event.snapshot.key)
            .child('comments')
            .child(commentEvent.snapshot.key)
            .update({'comment': comment});
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }
}
