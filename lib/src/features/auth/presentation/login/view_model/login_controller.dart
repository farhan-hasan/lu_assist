import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lu_assist/src/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:lu_assist/src/features/auth/data/model/user_model.dart';
import 'package:lu_assist/src/features/auth/presentation/login/view_model/login_generic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lu_assist/src/features/news_feed/presentation/view/news_feed_screen.dart';
import 'package:lu_assist/src/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:lu_assist/src/features/profile/presentation/view_model/profile_controller.dart';

import '../../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../../core/network/responses/failure_response.dart';
import '../../../../../core/router/router.dart';
import '../../../../../shared/dependency_injection/dependency_injection.dart';

final loginProvider = StateNotifierProvider<LoginController, LoginGeneric>(
    (ref) => LoginController(ref));

class LoginController extends StateNotifier<LoginGeneric> {
  LoginController(this.ref) : super(LoginGeneric());
  Ref ref;
  AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();
  ProfileRemoteDataSource profileRemoteDataSource = ProfileRemoteDataSource();
  final SharedPreferenceManager preferenceManager = sl.get();

  Future<bool> login({required String email, required String password}) async {
    state = state.update(isLoading: true);

    Either<Failure, User> response =
        await authRemoteDataSource.login(email: email, password: password);
    response.fold(
      (left) {
        BotToast.showText(text: left.message);
      },
      (right) async {
        BotToast.showText(text: "Welcome to LU Assist");
        final String? deviceToken = await FirebaseMessaging.instance.getToken();

        preferenceManager.insertValue<bool>(
            key: SharedPreferenceKeys.AUTH_STATE, data: true);
        preferenceManager.insertValue<String>(
            key: SharedPreferenceKeys.USER_UID, data: right.uid);
        preferenceManager.insertValue<String>(
            key: SharedPreferenceKeys.USER_EMAIL, data: right.email ?? "");

        ref.read(profileProvider.notifier).readProfile(right.uid);

        UserModel? userModel = ref.read(profileProvider).userModel;

        if(userModel != null) {
          userModel.deviceToken = deviceToken!;
          preferenceManager.insertValue<String>(
              key: SharedPreferenceKeys.USER_ROLE, data: userModel.role);
          await ref.read(profileProvider.notifier).updateProfile(userModel);
        }

        ref.read(goRouterProvider).go(
          NewsFeedScreen.route,
        );
      },
    );

    state = state.update(isLoading: false);
    return true;
  }
}
