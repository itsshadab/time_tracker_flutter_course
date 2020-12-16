import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User{
  final String uid;
  User({@required this.uid});
}

abstract class AuthBase{
  Future<User> currentUser();
  Stream<User> get onAuthStateChange;
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
}

class Auth implements AuthBase{

  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user){
    if(user == null){
      return null;
    }
    return User(uid: user.uid);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }
  @override
  Stream<User> get onAuthStateChange {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async{
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if(googleAccount != null){
      final googleAuth = await googleAccount.authentication;
      if(googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message:'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_BY_THE_USER',
        message:'Sign in aborted by the User',
      );
    }
  }

  @override
  Future<User> signInWithFacebook () async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(
        ['public_profile']
    );
    if(result.accessToken != null){
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_BY_THE_USER',
        message:'Sign in aborted by the User',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}