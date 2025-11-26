import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

@immutable
class RegisterState {
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String? errorMessage;

  const RegisterState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? errorMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      errorMessage: errorMessage,
    );
  }
}

class RegisterController extends StateNotifier<RegisterState> {
  RegisterController(this._firebaseAuth) : super(const RegisterState());

  final FirebaseAuth _firebaseAuth;

  Future<bool> createAccount({
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
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: trimmedPassword,
      );
      state = state.copyWith(isLoading: false, errorMessage: null);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthException(e),
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Nie udało się utworzyć konta. Spróbuj ponownie.',
      );
    }

    return false;
  }

  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
      isConfirmPasswordVisible: state.isConfirmPasswordVisible,
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
    );
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
      isPasswordVisible: state.isPasswordVisible,
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
    );
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(
        isLoading: state.isLoading,
        isPasswordVisible: state.isPasswordVisible,
        isConfirmPasswordVisible: state.isConfirmPasswordVisible,
        errorMessage: null,
      );
    }
  }

  String _mapFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'email-already-in-use':
        return 'Istnieje już konto z tym adresem email.';
      case 'invalid-email':
        return 'Adres email ma nieprawidłowy format.';
      case 'operation-not-allowed':
        return 'Rejestracja przy użyciu email/hasła jest wyłączona.';
      case 'weak-password':
        return 'Hasło jest zbyt słabe.';
      default:
        return 'Błąd rejestracji (${exception.code}). Spróbuj ponownie.';
    }
  }
}

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return RegisterController(firebaseAuth);
});

