import 'package:firebase_auth/firebase_auth.dart';
import '../models/UserModel.dart';
import 'UserCollectionSetup.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create custom UserModel object based on FirebaseUser
  UserModel? _getUserModelFromFirebase(User user) {
    return UserModel(uid: user.uid, email: user.email);
  }

  // auth change user stream
  // value will either be user object(sign-in) or null (sign-out)
  // need this info available to the entire widget tree so use Provider package
  Stream<UserModel?> get userStream {
    return _auth
        .authStateChanges()
        .map((User? someUser) => _getUserModelFromFirebase(someUser!));
  }

  Future getCurrentUserUID() async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

// Sign In W/ Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _getUserModelFromFirebase(user!);
    } catch (e) {
      print(e);
    }
  }

  Future register(
    String email,
    String firstName,
    String lastName,
    String residence,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      //Setting up users table data in Firestore via UserSetup Class
      await UserCollectionSetup(uid: user!.uid).updateUserData(
        email,
        firstName,
        lastName,
        residence,
      );
      return _getUserModelFromFirebase(user);
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
