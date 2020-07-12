import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User extends iDatabaseable{
  final String id;
  String name;
  String email;
  String token;
  dynamic createdAt;
  String platform;
  List<String> friendList;
  DocumentReference ref;

  User({
    @required this.id,
    this.name,
    this.email,
    this.token,
    this.createdAt,
    this.platform,
    this.friendList,
    this.ref,
  });

  factory User.fromJson(Map<String, dynamic> json, String ID) {
    return User(
      id: ID,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      createdAt: json['createdAt'] as dynamic,
      platform: json['platform'] as String,
      friendList: json['friendList'] as List<String>,
    );
  }
  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User newModule = User.fromJson(snapshot.data, snapshot.documentID);
    newModule.ref = snapshot.reference;
    return newModule;
  }
  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "email": email,
    "token": token,
    "createdAt" : createdAt,
    "platform" : platform,
    "friendList" : friendList,
    "ref" : ref,
  };

  DataRepo getRepo() {
    return DataRepo.fromRepo("users");
  }

  @override
  String toString() {
    return "$id  account of $name  email: $email";
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
      print("SETTTINGG ${user.displayName}");
      await Firestore.instance.collection("users").document(user.uid)
          .setData({
      'name' : user.displayName,
      'email' : user.email,
      });
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