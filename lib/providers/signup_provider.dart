import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpState {
  final String email;
  final String password;
  final String confirmPassword;

  SignUpState({this.email = '', this.password = '', this.confirmPassword = ''});

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}

final signUpProvider = StateNotifierProvider<SignUpNotifier, SignUpState>(
  (ref) => SignUpNotifier(),
);

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier() : super(SignUpState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }
}
