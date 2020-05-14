import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  FirebaseAuth firebaseAuth;
  UserService() {
    this.firebaseAuth = FirebaseAuth.instance;
  }

  Future<FirebaseUser> createuser(String email, String password) async {
    try {
      var result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    var result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    var currentUser = await firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getCuurentUser() async {
    print('${firebaseAuth.currentUser()}');
    return await firebaseAuth.currentUser();
  }
}
