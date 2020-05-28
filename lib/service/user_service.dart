import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserService({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password, String username}) async {
    try {
      final FirebaseAuth firebaseAuth1 = FirebaseAuth.instance;
      print('firbase instance${firebaseAuth1}');
      print('success');
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final FirebaseUser user = await firebaseAuth1.currentUser();
      print('user-${user},result-${result},UID-${user.uid},');
      var addusername = UserUpdateInfo();
      addusername.displayName = username;
      await user.updateProfile(addusername);
      await user.reload();

      print('result---------${result.user}');

      // await Firestore.instance.collection("users").document(email).setData({
      //   'username': username,
      //   'email': email,
      //   'password': password,
      //   'Blogs': false
      // });
      var data = {
        'uid': user.uid,
        'username': username,
        'email': email,
        'password': password,
        // 'Blogs': false
      };
      await FirebaseDatabase.instance
          .reference()
          .child('users')
          .push()
          .set(data);
      print('saving to DB in the end,${user}');
      return user.uid;
      //  return result.user;
    } catch (e) {
      print('failure in saving it ro the db');
    }
  }

  Future<void> signOut() async {
    print('calling signout');
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userid = user.uid;
    print('uid in service----${userid}');
    return userid;
  }
}
