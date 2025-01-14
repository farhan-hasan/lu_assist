import 'package:lu_assist/src/features/auth/presentation/signup/view_model/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  static const route = '/signup';

  static setRoute() => '/signup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupController = ref.watch(signUpProvider);
    return Scaffold();
  }
}
