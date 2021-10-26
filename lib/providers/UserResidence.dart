import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
var currentUserUid = auth.currentUser!.uid;
Stream<DocumentSnapshot> currentUserDocument =
    users.doc(currentUserUid).snapshots();

class UserResidence with ChangeNotifier {
  String _currentResidentName = '';

  String get currentResidentName => _currentResidentName;
}
