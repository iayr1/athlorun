import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// OAuth "Web client" ID of the Firebase project, needed by Google sign-in on
/// Android. Find it in Firebase console → Authentication → Sign-in method →
/// Google → Web SDK configuration, then pass it at build time:
/// `flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx.apps.googleusercontent.com`
const String kGoogleServerClientId =
    String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

/// Error shown to the user, with a friendly message.
class AuthFailure implements Exception {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => message;
}

/// Thin wrapper around Firebase Auth + Google sign-in.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  bool _googleReady = false;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<User> signInWithEmail(String email, String password) {
    return _guard(() async {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    });
  }

  Future<User> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) {
    return _guard(() async {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      if (displayName != null && displayName.trim().isNotEmpty) {
        await user.updateDisplayName(displayName.trim());
      }
      return user;
    });
  }

  Future<void> sendPasswordReset(String email) {
    return _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));
  }

  Future<User> signInWithGoogle() {
    return _guard(() async {
      if (kIsWeb) {
        final cred = await _auth.signInWithPopup(GoogleAuthProvider());
        return cred.user!;
      }
      final google = GoogleSignIn.instance;
      if (!_googleReady) {
        await google.initialize(
          serverClientId:
              kGoogleServerClientId.isEmpty ? null : kGoogleServerClientId,
        );
        _googleReady = true;
      }
      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthFailure('Google did not return an ID token.');
      }
      final cred = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
      return cred.user!;
    });
  }

  Future<void> signOut() async {
    if (_googleReady) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_messageFor(e));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthFailure('Google sign-in was cancelled.');
      }
      debugPrint('Google sign-in failed: $e');
      throw const AuthFailure(
        'Google sign-in is not available. Check the Firebase Google provider '
        'setup and try again.',
      );
    }
  }

  static String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}
