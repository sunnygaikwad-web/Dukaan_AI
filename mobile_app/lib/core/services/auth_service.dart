import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  // Current user
  User? get currentUser {
    try {
      return _auth?.currentUser;
    } catch (_) {
      return null;
    }
  }

  bool get isLoggedIn => currentUser != null;

  // Auth state stream
  Stream<User?> get authStateChanges {
    try {
      return _auth?.authStateChanges() ?? const Stream.empty();
    } catch (_) {
      return const Stream.empty();
    }
  }

  // ─── Email + Password Sign In ────────────────────────────────────────────
  Future<({User? user, String? error})> signInWithEmail(String email, String password) async {
    try {
      final auth = _auth;
      if (auth == null) {
        return (user: null, error: 'Auth service running in offline/demo mode.');
      }
      final credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return (user: credential.user, error: null);
    } on FirebaseAuthException catch (e) {
      return (user: null, error: _mapAuthError(e.code));
    } catch (e) {
      debugPrint('Sign in error: $e');
      return (user: null, error: 'Something went wrong. Please try again.');
    }
  }

  // ─── Email + Password Register ───────────────────────────────────────────
  Future<({User? user, String? error})> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final auth = _auth;
      if (auth == null) {
        return (user: null, error: 'Auth service running in offline/demo mode.');
      }
      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // Set display name
      await credential.user?.updateDisplayName(displayName.trim());
      await credential.user?.reload();
      return (user: auth.currentUser, error: null);
    } on FirebaseAuthException catch (e) {
      return (user: null, error: _mapAuthError(e.code));
    } catch (e) {
      debugPrint('Register error: $e');
      return (user: null, error: 'Something went wrong. Please try again.');
    }
  }

  // ─── Sign Out ────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    try {
      await _auth?.signOut();
    } catch (_) {}
  }

  // ─── Password Reset ─────────────────────────────────────────────────────
  Future<String?> sendPasswordReset(String email) async {
    try {
      final auth = _auth;
      if (auth == null) return null;
      await auth.sendPasswordResetEmail(email: email.trim());
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e.code);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // ─── Error Mapping ──────────────────────────────────────────────────────
  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Authentication error ($code). Please try again.';
    }
  }
}
