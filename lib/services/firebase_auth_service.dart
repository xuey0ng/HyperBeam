import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  factory User.fromJson(Map<String, dynamic> json, String ID) {
    return User(
        id: ID,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
    );
  }
  factory User.fromSnapshot(DocumentSnapshot snapshot) {

    User newModule = User.fromJson(snapshot.data, snapshot.documentID);
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
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    if (authResult.additionalUserInfo.isNewUser) {
      print("HIT HERE");
      await Firestore.instance.collection("users").document(user.uid).setData({
      'firstName' : null,
      'lastName' : user.displayName,
      'email' : user.email,
      });
      print("DONE");
    }
    print("google sign in success ${user.uid}");
    return _userFromFirebase(user);
  }

  void signOutGoogle() async{
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  User _userFromFirebase(FirebaseUser user) {
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