import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  });
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}

class FirebaseAuthRemoteDataSource implements IAuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;

  FirebaseAuthRemoteDataSource({fb.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((fbUser) {
      if (fbUser == null) return null;
      return UserModel.fromFirebaseUser(fbUser);
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException('User could not be found after login.');
      }
      return UserModel.fromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException('Account creation failed.');
      }

      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName.trim());
        await user.reload();
      }

      final updatedUser = _firebaseAuth.currentUser ?? user;
      return UserModel.fromFirebaseUser(updatedUser);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  String _mapFirebaseError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user registered with this email address.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password. Please verify your credentials.';
      case 'email-already-in-use':
        return 'This email address is already registered. Please sign in.';
      case 'invalid-email':
        return 'Please enter a valid email address format.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again in a few moments.';
      case 'network-request-failed':
        return 'Network connection error. Please check your internet connection.';
      default:
        return e.message ?? 'Authentication failed. Please check credentials.';
    }
  }
}
