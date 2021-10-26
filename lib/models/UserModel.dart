import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String? uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? residence;

  UserModel(
      {this.uid, this.email, this.firstName, this.lastName, this.residence});

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getData() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get();
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> get currentUser {
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .get();
  // }
}
