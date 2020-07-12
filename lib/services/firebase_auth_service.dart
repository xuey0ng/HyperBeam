import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User {
  final String id;
  String firstName;
  String lastName;
  String email;

  User({@required this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  @override
  String toString() {
    return "$id  account of $firstName   $lastName  email: $email";
  }
}

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    return user == null ? null : User(id: user.uid);
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