import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Result wrapper for authentication operations
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;

  AuthResult._({required this.isSuccess, this.user, this.errorMessage});

  /// Creates a successful result
  factory AuthResult.success(User? user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  /// Creates a failure result
  factory AuthResult.failure(String errorMessage) {
    return AuthResult._(isSuccess: false, errorMessage: errorMessage);
  }
}

/// Service class for handling Firebase Authentication
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user
  static User? get currentUser => _auth.currentUser;

  /// Get current user stream
  static Stream<User?> get userStream => _auth.authStateChanges();

  /// Sign up with email and password
  static Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Create user account
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName.trim());
        await userCredential.user?.reload();
      }

      // Send email verification
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }

      return AuthResult.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Sign up error: $e');
      return AuthResult.failure('An unexpected error occurred during sign up');
    }
  }

  /// Sign in with email and password
  static Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      return AuthResult.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Sign in error: $e');
      return AuthResult.failure('An unexpected error occurred during sign in');
    }
  }

  /// Sign in anonymously
  static Future<AuthResult> signInAnonymously() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      return AuthResult.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Anonymous sign in error: $e');
      return AuthResult.failure('Failed to sign in anonymously');
    }
  }

  /// Send password reset email
  static Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      // Password reset email sent successfully, user may not be signed in so return success without user
      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Password reset error: $e');
      return AuthResult.failure('Failed to send password reset email');
    }
  }

  /// Sign out
  static Future<AuthResult> signOut() async {
    try {
      await _auth.signOut();
      // After sign out, currentUser is null
      return AuthResult.success(null);
    } catch (e) {
      debugPrint('Sign out error: $e');
      return AuthResult.failure('Failed to sign out');
    }
  }

  /// Delete current user account
  static Future<AuthResult> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user is currently signed in');
      }

      await user.delete();
      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Delete account error: $e');
      return AuthResult.failure('Failed to delete account');
    }
  }

  /// Update user profile
  static Future<AuthResult> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user is currently signed in');
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName.trim());
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
      return AuthResult.success(_auth.currentUser);
    } catch (e) {
      debugPrint('Update profile error: $e');
      return AuthResult.failure('Failed to update profile');
    }
  }

  /// Update user email
  static Future<AuthResult> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user is currently signed in');
      }

      await user.updateEmail(newEmail.trim());
      await user.reload();
      return AuthResult.success(_auth.currentUser);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Update email error: $e');
      return AuthResult.failure('Failed to update email');
    }
  }

  /// Update user password
  static Future<AuthResult> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user is currently signed in');
      }

      await user.updatePassword(newPassword);
      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Update password error: $e');
      return AuthResult.failure('Failed to update password');
    }
  }

  /// Reauthenticate user (required for sensitive operations)
  static Future<AuthResult> reauthenticateWithPassword(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user is currently signed in');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Reauthentication error: $e');
      return AuthResult.failure('Failed to reauthenticate');
    }
  }

  /// Send email verification
  static Future<AuthResult> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user is currently signed in');
      }

      if (user.emailVerified) {
        return AuthResult.failure('Email is already verified');
      }

      await user.sendEmailVerification();
      return AuthResult.success(user);
    } catch (e) {
      debugPrint('Email verification error: $e');
      return AuthResult.failure('Failed to send email verification');
    }
  }

  /// Check if user email is verified
  static bool get isEmailVerified {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  /// Reload current user data
  static Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  /// Convert Firebase Auth exceptions to user-friendly messages
  static String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address';
      case 'wrong-password':
        return 'Incorrect password. Please try again';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'weak-password':
        return 'Password should be at least 6 characters long';
      case 'email-already-in-use':
        return 'An account already exists with this email address';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'requires-recent-login':
        return 'Please sign in again to perform this action';
      case 'credential-already-in-use':
        return 'This credential is already associated with another account';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      case 'missing-verification-code':
        return 'Please enter the verification code';
      case 'missing-verification-id':
        return 'Missing verification ID';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later';
      case 'captcha-check-failed':
        return 'Captcha verification failed';
      case 'missing-phone-number':
        return 'Please enter a phone number';
      case 'invalid-phone-number':
        return 'Please enter a valid phone number';
      case 'missing-code':
        return 'Please enter the verification code';
      case 'invalid-code':
        return 'Invalid verification code';
      case 'expired-action-code':
        return 'This verification link has expired';
      case 'invalid-action-code':
        return 'Invalid or expired verification link';
      case 'user-token-expired':
        return 'Your session has expired. Please sign in again';
      default:
        debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
        return e.message ?? 'An authentication error occurred';
    }
  }

  /// Initialize authentication listener (call this in main.dart)
  static void initializeAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in: ${user.email ?? 'Anonymous'}');
      }
    });
  }

  /// Get user display name or fallback
  static String getUserDisplayName() {
    final user = _auth.currentUser;
    if (user == null) return 'Guest';

    if (user.isAnonymous) return 'Anonymous User';

    return (user.displayName?.isNotEmpty == true)
        ? user.displayName!
        : user.email?.split('@')[0] ?? 'User';
  }

  /// Check if user is anonymous
  static bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  /// Check if user is signed in
  static bool get isSignedIn => _auth.currentUser != null;
}
