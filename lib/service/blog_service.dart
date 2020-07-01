import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      var tempComments;
      var commentsList = new List<Comment>();
      var likesList = new List<String>();
      if (data[key]['likes'] != null) {
        tempLikes = data[key]['likes'];
        for (var like in tempLikes) {
          likesList.add(like.toString());
        }
      }
      if (data[key]['comments'] != null) {
        //  print('comments------------ ${data[key]['comments']}');
        tempComments = data[key]['comments'];
        //tempComments.add(data[key]['comments']);
        //print('tempcomment ${tempComments}');

        for (var comment in tempComments) {
          //   print('comments inside for------------ ${comment}');
          if (comment != null) {
            var newComment = new Comment(
              username: comment['username'],
              date: comment['date'],
              comment: comment['comment'],
            );

            //  print('comment inside for ${comment}');
            commentsList.add(newComment);
            //print('commentList inside for ${commentsList}');
          }
        }
      }
      Blogs blog = new Blogs(
          image: data[key]['image'],
          uid: data[key]['uid'],
          authorname: data[key]['authorname'],
          title: data[key]['title'],
          description: data[key]['description'],
          likes: likesList,
          comments: commentsList,
          date: data[key]['date'],
          time: data[key]['time'],
          timeStamp: data[key]['timeStamp']);
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
          Blogs blog = new Blogs(
              image: data[key]['image'],
              uid: data[key]['uid'],
              authorname: data[key]['authorname'],
              title: data[key]['title'],
              description: data[key]['description'],
              likes: likesList,
              comments: commentsList,
              date: data[key]['date'],
              time: data[key]['time'],
              timeStamp: data[key]['timeStamp']);
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
  Future<void> saveToDatabase(
    String url,
    String _mytitlevalue,
    String _myvalue,
    String category,
  ) async {
    try {
      //  var url = uploadImage();
      print('url:$url');
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
        'date': date,
        'time': time,
        'timeStamp': timeStamp,
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
    print('inside service upload image');
    final StorageReference iamgeref =
        FirebaseStorage.instance.ref().child("Blog images");
    var timekey = new DateTime.now();
    print('image -------${sampleImage}');
    final StorageUploadTask uploadImage =
        iamgeref.child(timekey.toString() + '.jpg').putFile(sampleImage);
    var imageurl = await uploadImage.onComplete;
    var imageurl1 = await imageurl.ref.getDownloadURL();
    url = imageurl1.toString();
    print('url -------${url}');
    return url;
    // try {
    //   await saveToDatabase(
    //     url,
    //     mytitlevalue,
    //     myvalue,
    //     category,
    //   );
    // } catch (e) {
    //   print(e.toString());
    // }
    // }
  }

//To validate form and save
  // bool validateandSave() {
  //   final formKey = new GlobalKey<FormState>();
  //   final form = formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     return true;
  //   }
  // }

//To Search a blog in firebase
  Future searchBlogs(String searchKey) async {
    print('search service ${searchKey}');
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
          print('test123 ${data[key]['likes']}');
          List<String> likesList = [];
          for (var like in data[key]['likes']) {
            print('like ${like}');
            likesList.add(like);
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

          Blogs blog = new Blogs(
              image: data[key]['image'],
              uid: data[key]['uid'],
              authorname: data[key]['authorname'],
              title: data[key]['title'],
              description: data[key]['description'],
              likes: likesList,
              comments: commentsList,
              date: data[key]['date'],
              time: data[key]['time'],
              timeStamp: data[key]['timeStamp']);

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

  Future setLikes(int blogtimeStamp, var uid, List<String> likes) async {
    List<String> likesData = likes;
    if (likes.contains(uid)) {
      likesData.remove(uid);
      print('likes removed to the list');
    } else {
      likesData.add(uid);
      print('likes added to the list');
    }
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
          .update({'likes': likesData});
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
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
      print('inside onerrod ${o}');
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  Future deleteComments(
    int blogsTimeStamp,
    int commentTimeStamp,
  ) async {
    print('values in delete Service timeStamp$commentTimeStamp,');
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
        //  print('listening comment event ${commentEvent.snapshot.key}');
        FirebaseDatabase.instance
            .reference()
            .child('blogs')
            .child(event.snapshot.key)
            .child('comments')
            .child(commentEvent.snapshot.key)
            .remove();
        //   .update({'comment': 'testsomething'});
        print('deleted ${commentEvent.snapshot.key}');
      });
      print('snapshot key ${event.snapshot.key}');
    }, onError: (Object o) {
      print('inside onerrod ${o}');
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  Future editComments(
      int blogsTimeStamp, int commentTimeStamp, String comment) async {
    print('values in edit comment Service $commentTimeStamp  $comment,');
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
        //  print('listening comment event ${commentEvent.snapshot.key}');
        FirebaseDatabase.instance
            .reference()
            .child('blogs')
            .child(event.snapshot.key)
            .child('comments')
            .child(commentEvent.snapshot.key)
            .update({'comment': comment});
        print('edited ${comment}');
      });
      print('snapshot key ${event.snapshot.key}');
    }, onError: (Object o) {
      print('inside onerrod ${o}');
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }
}
