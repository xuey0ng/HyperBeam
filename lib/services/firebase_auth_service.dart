import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User {
  final String id;
  String firstName;
  String lastName;
  String email;
  DocumentReference ref;

  User({@required this.id,
    @required this.firstName,
    this.lastName,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json, DocumentSnapshot snapshot) {
    return User(
        id: snapshot.reference.toString(),
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
    );
  }
  factory User.fromSnapshot(DocumentSnapshot snapshot) {

    User newModule = User.fromJson(snapshot.data, snapshot);
    newModule.ref = snapshot.reference;
    return newModule;
  }


  @override
  String toString() {
    return "$id  account of $firstName   $lastName  email: $email";
  }
}

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    //Firestore.instance.collection('user').document(user.uid).
    return user == null ? null : User(id: user.uid, email: user.email);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(result.user);
  }

  Future<User> createWithEmailAndPassword(String email, String password) async {
    AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(result.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}