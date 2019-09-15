import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forward/core/models/user_model.dart';
import 'package:forward/repositories/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  NoUser
}

class AppUser {
  FirebaseUser firebaseUser;
  User user;
}

class AuthRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  String errorMessage = '';
  AppUser appUser = new AppUser();
  GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;

  AuthRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  /// Sends the code to the specified phone number.
  Future<void> sendCodeToPhoneNumber(
    String phoneNumber,
    int seconds,
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    PhoneCodeSent codeSent,
    PhoneVerificationCompleted verificationCompleted,
    PhoneVerificationFailed verificationFailed,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(seconds: seconds),
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          codeSent: codeSent,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Sign in using an sms code as input.
  Future<bool> signInWithPhoneNumber(
      String smsCode, String verificationId) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);

      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();

      throw e;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<FirebaseUser> getCurrentUser() {
    return FirebaseAuth.instance.currentUser();
  }

  void checkAuthStatus() {
    this._onAuthStateChanged(_user);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      errorMessage = '';
    } else {
      _user = firebaseUser;
      appUser.firebaseUser = _user;
      appUser.user = await UserRepository.getUser(appUser.firebaseUser.uid);
      errorMessage = '';

      if (appUser.user == null) {
        _status = Status.NoUser;
        errorMessage = 'No user was found';
      } else {
        _status = Status.Authenticated;
      }
    }
    notifyListeners();
  }
}
