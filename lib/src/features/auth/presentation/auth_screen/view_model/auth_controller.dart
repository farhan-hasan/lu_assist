import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:lu_assist/src/core/database/local/shared_preference/shared_preference_manager.dart';
import 'package:lu_assist/src/core/network/responses/failure_response.dart';
import 'package:lu_assist/src/core/network/responses/success_response.dart';
import 'package:lu_assist/src/features/auth/domain/usecases/change_email_usecase.dart';
import 'package:lu_assist/src/shared/dependency_injection/dependency_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_generic.dart';

final authProvider = StateNotifierProvider<AuthController, AuthGeneric>(
    (ref) => AuthController(ref));

class AuthController extends StateNotifier<AuthGeneric> {
  AuthController(this.ref) : super(AuthGeneric());
  Ref ref;

  Future<bool> changeEmail({required String email}) async {
    return true;
  }
}
