// import 'package:firebase_auth/firebase_auth.dart';

// class UserService {
//   FirebaseAuth firebaseAuth;
//   UserService() {
//     this.firebaseAuth = FirebaseAuth.instance;
//   }

//   Future<FirebaseUser> createuser(String email, String password) async {
//     // try {
//     print('$email , $password in service');
//     var result = await firebaseAuth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     print('authresult ${result.user.email}');
//     return result.user;
//     // } catch (e) {
//     //   throw Exception(e.toString());
//     // }
//   }

//   Future<FirebaseUser> signIn(String email, String password) async {
//     var result = await firebaseAuth.signInWithEmailAndPassword(
//         email: email, password: password);
//     print('$email $password in sigin service');
//     return result.user;
//   }

//   Future<void> signOut() async {
//     await firebaseAuth.signOut();
//   }

//   Future<bool> isSignedIn() async {
//     var currentUser = await firebaseAuth.currentUser();
//     return currentUser != null;
//   }

//   Future<FirebaseUser> getCuurentUser() async {
//     print('${firebaseAuth.currentUser()}');
//     return await firebaseAuth.currentUser();
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> signUp({String email, String password}) async {
    try {
      final FirebaseAuth firebaseAuth1 = FirebaseAuth.instance;
      print('firbase instance${firebaseAuth1}');
      print('success');
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('${result.user}');
      return result.user;
    } catch (e) {
      print('failure');
    }
  }

  Future<void> signOut() async {
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
    return (await _firebaseAuth.currentUser()).email;
  }
}
