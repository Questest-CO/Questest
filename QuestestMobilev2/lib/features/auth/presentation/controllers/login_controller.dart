import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../providers/auth_providers.dart';

/// Represents the UI state of the login form.
@immutable
class LoginState {
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage;

  const LoginState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage,
    );
  }
}

/// State notifier that coordinates Firebase email/password sign-in.
class LoginController extends StateNotifier<LoginState> {
  LoginController(this._firebaseAuth, this._googleSignIn) : super(const LoginState());

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Attempts to sign the user in with the provided credentials.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Podaj adres email oraz hasło.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: trimmedPassword,
      );
      state = state.copyWith(isLoading: false, errorMessage: null);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthException(e),
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Coś poszło nie tak. Spróbuj ponownie później.',
      );
    }
  }

  /// Sends a password reset email. Returns `null` on success or an error message.
  Future<String?> sendPasswordReset(String email) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      return 'Podaj adres email.';
    }

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: trimmedEmail);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e);
    } catch (_) {
      return 'Nie udało się wysłać wiadomości resetującej hasło.';
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          state = state.copyWith(isLoading: false);
          return;
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
      }
      state = state.copyWith(isLoading: false, errorMessage: null);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthException(e),
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Nie udało się zalogować przez Google. Spróbuj ponownie.',
      );
    }
  }

  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
      errorMessage: state.errorMessage,
    );
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(
        isLoading: state.isLoading,
        isPasswordVisible: state.isPasswordVisible,
        errorMessage: null,
      );
    }
  }

  String _mapFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Adres email ma nieprawidłowy format.';
      case 'user-disabled':
        return 'Konto zostało zablokowane.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Nieprawidłowy email lub hasło.';
      case 'too-many-requests':
        return 'Zbyt wiele prób logowania. Spróbuj ponownie później.';
      default:
        return 'Błąd logowania (${exception.code}). Spróbuj ponownie.';
    }
  }
}

/// Provider that exposes [LoginController] state and actions to the UI.
final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return LoginController(firebaseAuth, googleSignIn);
});


