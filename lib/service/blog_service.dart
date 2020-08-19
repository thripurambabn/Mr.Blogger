import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:mr_blogger/data/blog_dao.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/comment.dart';

import 'package:mr_blogger/service/user_service.dart';

class BlogsService {
  var userService = UserService();
  BlogDao _blogsDao = BlogDao();
  int value = 4;

//To fetch first set of blogs from the firebase database
  Future<List<Blogs>> getblogs() async {
    List<Blogs> blogsList = [];
    bool isFollowing;
    bool isBookMarked;
    var tempfollowing = [];
    var followingList = List<String>();
    var tempBookMark = [];
    var bookMarkedList = List<String>();
    Query blogsref = FirebaseDatabase.instance
        .reference()
        .child('blogs')
        .orderByChild('timeStamp')
        .limitToFirst(value);
    final DataSnapshot snapshot = await blogsref.once();
    var refkey = snapshot.value.keys;
    var data = snapshot.value;
    for (var key in refkey) {
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
            if (data1[key]['bookMarks'] != null) {
              tempBookMark = data1[key]['bookMarks'];
              for (var bookMark in tempBookMark) {
                bookMarkedList.add(bookMark.toString());
              }
            }
          }
        }
      } catch (e) {
        print(e);
      }

      isBookMarked = bookMarkedList.contains(key);
      isFollowing = followingList.contains(data[key]['uid']);
      if (isFollowing == true || data[key]['blogPrivacy'] == false) {
        var tempLikes = [];
        var tempImages = [];
        var tempComments;
        var commentsList = new List<Comment>();
        var likesList = new List<String>();
        var imagesList = new List<String>();
        if (data[key]['likes'] != null) {
          tempLikes = data[key]['likes'];

          for (var like in tempLikes) {
            likesList.add(like.toString());
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
            isFollowing: isFollowing,
            date: data[key]['date'],
            category: data[key]['category'],
            time: data[key]['time'],
            timeStamp: data[key]['timeStamp'],
            blogPrivacy: data[key]['blogPrivacy'],
            isBookMarked: isBookMarked);
        blogsList.add(blog);
        await _blogsDao.insert(blog);
      }
    }

    //sort blogs on timestamp
    blogsList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    // await _blogsDao.insert(blogsList);
    return blogsList;
  }

//To fetch more blogs from the firebase database on scroll(pagination)
  Future<List<Blogs>> getMoreBlogs(List<Blogs> blogs) async {
    List<Blogs> blogsList = [];
    bool isFollowing;
    var queryTimeStamp = blogs[blogs.length - 1].timeStamp;
    var tempfollowing = [];
    var followingList = List<String>();
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
          if (isFollowing == true || data[key]['blogPrivacy'] == false) {
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
                isFollowing: isFollowing,
                date: data[key]['date'],
                time: data[key]['time'],
                category: data[key]['category'],
                timeStamp: data[key]['timeStamp'],
                blogPrivacy: data[key]['blogPrivacy']);
            blogsList.add(blog);
            await _blogsDao.insert(blog);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    //sort blogs on timestamp
    blogsList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    //await _blogsDao.insert(blogsList);
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
    List<Blogs> blogsList = [];
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

  Future setFollow(bool isFollowing, var uid) async {
    var userid = await userService.getUserID();
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .orderByChild('uid')
        .equalTo(userid)
        .onChildAdded
        .listen((Event event) {
      var tempfollowing = [];
      var followingList = List<String>();
      if (event.snapshot.value['following'] != null) {
        tempfollowing = event.snapshot.value['following'];
        for (var follower in tempfollowing) {
          followingList.add(follower.toString());
        }
      }
      if (isFollowing) {
        followingList.add(uid);
      } else {
        followingList.remove(uid);
      }
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(event.snapshot.key)
          .update({'following': followingList});
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });

    FirebaseDatabase.instance
        .reference()
        .child('users')
        .orderByChild('uid')
        .equalTo(uid)
        .onChildAdded
        .listen((Event event) {
      var tempfollowers = [];
      var followersList = List<String>();
      if (event.snapshot.value['followers'] != null) {
        tempfollowers = event.snapshot.value['followers'];
        for (var follower in tempfollowers) {
          followersList.add(follower.toString());
        }
      }
      if (isFollowing) {
        followersList.add(userid);
      } else {
        followersList.remove(userid);
      }
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(event.snapshot.key)
          .update({'followers': followersList});
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  Future setBookMark(bool isBookMarked, Blogs blog) async {
    var userid = await userService.getUserID();
    Blogs newBlog = new Blogs(
        image: blog.image,
        uid: blog.uid,
        authorname: blog.authorname,
        title: blog.title,
        description: blog.description,
        likes: blog.likes,
        comments: blog.comments,
        isFollowing: blog.isFollowing,
        date: blog.date,
        time: blog.time,
        category: blog.category,
        timeStamp: blog.timeStamp,
        blogPrivacy: blog.blogPrivacy);

    DatabaseReference blogsref =
        FirebaseDatabase.instance.reference().child('blogs');
    final DataSnapshot snapshot = await blogsref
        .orderByChild('timeStamp')
        .equalTo(newBlog.timeStamp)
        .once();

    FirebaseDatabase.instance
        .reference()
        .child('users')
        .orderByChild('uid')
        .equalTo(userid)
        .onChildAdded
        .listen((Event event) {
      var tempBookmarks = [];
      var bookMarksList = List<String>();
      if (event.snapshot.value['bookMarks'] != null) {
        tempBookmarks = event.snapshot.value['bookMarks'];
        for (var bookMark in tempBookmarks) {
          bookMarksList.add(bookMark.toString());
        }
      }
      var key = snapshot.value.keys.toString();
      var blogKey = key.substring(1, key.length - 1);

      if (isBookMarked) {
        bookMarksList.add(blogKey);
      } else {
        bookMarksList.remove(blogKey);
      }
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(event.snapshot.key)
          .update({'bookMarks': bookMarksList});
    }, onError: (Object o) {
      final DatabaseError error = o;
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
