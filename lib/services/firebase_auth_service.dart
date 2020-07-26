import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User {
  final String id;
  String firstName;
  String lastName;
  String email;
<<<<<<< HEAD
  String token;
  dynamic createdAt;
  String platform;
  List<String> friendList;
  DocumentReference ref;
  bool verified;
=======
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3

  User({@required this.id,
    this.firstName,
    this.lastName,
    this.email,
<<<<<<< HEAD
    this.token,
    this.createdAt,
    this.platform,
    this.friendList,
    this.ref,
    this.verified,
=======
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
  });

  @override
  String toString() {
    return "$id  account of $firstName   $lastName  email: $email";
  }
}

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;
<<<<<<< HEAD
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

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
    return user == null ? null : User(id: user.uid, email: user.email, verified: user.isEmailVerified);
=======

  User _userFromFirebase(FirebaseUser user) {
    return user == null ? null : User(id: user.uid);
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
  }

  Stream<User> get onAuthStateChanged {
    print("GETTING");
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    print("Signing in ");
    if(!result.user.isEmailVerified) {
      print("Signing out");
      _firebaseAuth.signOut();
    }
    return _userFromFirebase(result.user);
  }

  Future<User> createWithEmailAndPassword(String email, String password) async {
    AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    User user1 = _userFromFirebase(result.user);
    try {
      await result.user.sendEmailVerification();
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
      return null;
    }
    return user1;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}