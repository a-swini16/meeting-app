import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthResult {
  final bool success;
  final String message;

  AuthResult({required this.success, required this.message});
}

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get user => _auth.currentUser;

  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        return AuthResult(success: false, message: 'Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection('users').doc(user.uid).set({
            'username': user.displayName ?? 'User',
            'uid': user.uid,
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        return AuthResult(success: true, message: 'Successfully signed in with Google');
      }
      return AuthResult(success: false, message: 'Failed to get user information');
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: _getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Google Sign-in Error: $e');
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Validate input
      if (email.trim().isEmpty || password.trim().isEmpty) {
        return AuthResult(success: false, message: 'Please fill in all fields');
      }

      if (!_isValidEmail(email)) {
        return AuthResult(success: false, message: 'Please enter a valid email address');
      }

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return AuthResult(success: true, message: 'Successfully signed in');
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: _getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Email Sign-in Error: $e');
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  Future<AuthResult> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      // Validate input
      if (email.trim().isEmpty || password.trim().isEmpty || username.trim().isEmpty) {
        return AuthResult(success: false, message: 'Please fill in all fields');
      }

      if (!_isValidEmail(email)) {
        return AuthResult(success: false, message: 'Please enter a valid email address');
      }

      if (password.length < 6) {
        return AuthResult(success: false, message: 'Password must be at least 6 characters');
      }

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (cred.user != null) {
        // Update display name
        await cred.user!.updateDisplayName(username.trim());
        
        // Create user document in Firestore
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username.trim(),
          'uid': cred.user!.uid,
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        return AuthResult(success: true, message: 'Account created successfully');
      }
      return AuthResult(success: false, message: 'Failed to create account');
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: _getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Sign-up Error: $e');
      return AuthResult(success: false, message: 'An unexpected error occurred');
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign-out Error: $e');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }
}