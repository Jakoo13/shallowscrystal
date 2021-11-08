import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shallows/allConstants/firestore_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  unititialized,
  authenticated,
  authenticating,
  authenticationError,
  authenticationCanceled,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  //Status get status => _status;

  AuthProvider({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.prefs,
  });

  String? getUserFirebaseId() {
    return prefs.getString(FirestoreConstants.id);
  }

// did this one differently than video https://www.youtube.com/watch?v=tKjHsj8_fDY&t=349s
  Future<bool> isLoggedIn() async {
    bool isLoggedIn = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    if (isLoggedIn &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  // Future<bool> handleSignIn() asyn {
  //   _status = Status.authenticating;
  //   notifyListeners();
  // }
}
