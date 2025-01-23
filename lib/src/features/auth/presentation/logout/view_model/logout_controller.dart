import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:lu_assist/src/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:lu_assist/src/features/auth/presentation/login/view/login_screen.dart';
import 'package:lu_assist/src/features/auth/presentation/logout/view_model/logout_generic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../../core/network/responses/failure_response.dart';
import '../../../../../core/network/responses/success_response.dart';
import '../../../../../core/router/router.dart';
import '../../../../../shared/dependency_injection/dependency_injection.dart';

final logoutProvider = StateNotifierProvider<LogoutController, LogoutGeneric>(
    (ref) => LogoutController(ref));

class LogoutController extends StateNotifier<LogoutGeneric> {
  LogoutController(this.ref) : super(LogoutGeneric());
  Ref ref;
  final SharedPreferenceManager preferenceManager = sl.get();
  AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();

  Future<bool> logout() async {
    String uid = preferenceManager.getValue(key: SharedPreferenceKeys.USER_UID);
    state = state.update(isLoading: true);
    bool isSuccess = false;
    Either<Failure, Success> response = await authRemoteDataSource.logout();
    response.fold(
          (left) {
        BotToast.showText(text: left.message);
      },
          (right) async {
        BotToast.showText(text: "See you again!");
        //await ref.read(profileProvider.notifier).readProfile(uid);
        preferenceManager.insertValue<bool>(
            key: SharedPreferenceKeys.AUTH_STATE, data: false);
        ref.read(goRouterProvider).go(LoginScreen.route);
      },
    );
    state = state.update(isLoading: false);
    return isSuccess;
  }
}

class AuthScreen {
}
