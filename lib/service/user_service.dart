import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
//auth service constructor
  UserService({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

//google signin with firebase
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

//firebase sign in with user email and password
  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

//firebase signup with user details
  Future<void> signUp({String email, String password, String username}) async {
    try {
      final FirebaseAuth firebaseAuth1 = FirebaseAuth.instance;
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final FirebaseUser user = await firebaseAuth1.currentUser();

      var addusername = UserUpdateInfo();
      addusername.displayName = username;
      await user.updateProfile(addusername);
      await user.reload();

      var data = {
        'uid': user.uid,
        'username': username,
        'email': email,
        'password': password,
      };
      await FirebaseDatabase.instance
          .reference()
          .child('users')
          .push()
          .set(data);

      return user.uid;
    } catch (e) {
      print('failure in saving it ro the db');
    }
  }

//firebase signout
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

//check if user is logged in
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

//to get current logged in user details
  Future<FirebaseUser> getUser() async {
    final user = await _firebaseAuth.currentUser();
    return user;
  }

//get current logged in user id
  Future<String> getUserID() async {
    final user = await _firebaseAuth.currentUser();
    final userid = user.uid;

    return userid;
  }

//get current logged in user name
  Future<String> getUserName() async {
    final user = await _firebaseAuth.currentUser();
    final username = user.displayName;
    return username;
  }

//to read data from local storage
  Future<String> read() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await _firebaseAuth.currentUser();
    final uid = user.uid;
    final displayName = user.displayName;
    final email = user.email;
    print('read string ${displayName},${email}');
    prefs.setString("displayName", displayName);
    prefs.setString("email", email);
    prefs.setString('uid', uid);
  }

//to write data to local storage
  Future<Users> save() async {
    final prefs = await SharedPreferences.getInstance();
    final displayName = prefs.getString(
      "displayName",
    );
    print('displayname ${displayName}');
    final email = prefs.getString("email");
    final uid = prefs.getString('uid');
    print('display name and email ${displayName} ${email} ${uid}');
    Users user = new Users(displayName: displayName, email: email, uid: uid);
    return user;
  }
}
