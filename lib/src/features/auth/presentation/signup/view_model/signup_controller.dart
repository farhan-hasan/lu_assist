
import 'package:lu_assist/src/features/auth/presentation/signup/view_model/signup_generic.dart';
import 'package:lu_assist/src/shared/dependency_injection/dependency_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpProvider = StateNotifierProvider<SignupController, SignupGeneric>(
  (ref) => SignupController(ref),
);

class SignupController extends StateNotifier<SignupGeneric> {
  SignupController(this.ref) : super(SignupGeneric());
  Ref ref;


  Future<bool> signUp(
      {required String email, required String password}) async {
    return true;
  }
}
