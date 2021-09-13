import 'package:firebase_auth/firebase_auth.dart';
import '../models/myUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create custom MyUser object based on FirebaseUser
  MyUser? _getMyUserFromFirebase(User user) {
    return MyUser(uid: user.uid, email: user.email);
  }

  // auth change user stream
  // value will either be user object(sign-in) or null (sign-out)
  // need this info available to the entire widget tree so use Provider package
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _getMyUserFromFirebase(user!));
  }

// Sign In W/ Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _getMyUserFromFirebase(user!);
    } catch (e) {
      print(e);
    }
  }

  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _getMyUserFromFirebase(user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-passord') {
        print('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future logOut() async {
    try {
      return await _auth.signOut();
      //  errorMessage = '';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
