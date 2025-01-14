import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:lu_assist/src/core/network/responses/failure_response.dart';
import 'package:lu_assist/src/core/network/responses/success_response.dart';
import 'package:lu_assist/src/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:lu_assist/src/features/auth/presentation/forget_password/view_model/forgot_password_generic.dart';
import 'package:lu_assist/src/shared/dependency_injection/dependency_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordGeneric>(
  (ref) => ForgotPasswordController(ref),
);

class ForgotPasswordController extends StateNotifier<ForgotPasswordGeneric> {
  ForgotPasswordController(this.ref) : super(ForgotPasswordGeneric());
  Ref ref;


  void sendPasswordResetEmail({required String email}) async {
    return;
  }
}
