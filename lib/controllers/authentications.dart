import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

Future<bool> googlesignIn() async {
  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    AuthResult result = await auth.signInWithCredential(credential);

    FirebaseUser user = await auth.currentUser();
    print(user.uid);

    Future.value(true);
  }
}

Future<FirebaseUser> signin(
    String email, String password, BuildContext context) async {
  try {
    AuthResult result =
        await auth.signInWithEmailAndPassword(email: email, password: email);
    FirebaseUser user = result.user;
    // return Future.value(true);
    return Future.value(user);
  } catch (e) {
    // simply passing error code as a message
    print(e.code);
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        print("Invalid email");
        break;
      case 'ERROR_WRONG_PASSWORD':
        print("wrong password");
        break;
      case 'ERROR_USER_NOT_FOUND':
        print("user not found");
        break;
      case 'ERROR_USER_DISABLED':
        print("error user disabled");
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        print("error too many requests");
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        print("error operation not allowed");
        break;
    }
    // since we are not actually continuing after displaying errors
    // the false value will not be returned
    // hence we don't have to check the valur returned in from the signin function
    // whenever we call it anywhere
    return Future.value(null);
  }
}

Future<FirebaseUser> signUp(
    String email, String password, BuildContext context) async {
  try {
    AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email, password: email);
    FirebaseUser user = result.user;
    return Future.value(user);
    // return Future.value(true);
  } catch (error) {
    switch (error.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        print("email already in use");
        break;
      case 'ERROR_INVALID_EMAIL':
        print("error invalid email");
        break;
      case 'ERROR_WEAK_PASSWORD':
        print("error weak password");
        break;
    }
    return Future.value(null);
  }
}

Future<bool> signOut() async {
  FirebaseUser user = await auth.currentUser();
  if (user.providerData[1].providerId == 'google.com') {
    await googleSignIn.disconnect();
  }

  auth.signOut();
  return Future.value(true);
}
