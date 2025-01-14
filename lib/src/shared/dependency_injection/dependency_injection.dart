import 'package:lu_assist/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:lu_assist/src/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:lu_assist/src/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:lu_assist/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:lu_assist/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lu_assist/src/features/auth/domain/usecases/signup_usecase.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/domain/usecases/change_email_usecase.dart';

final sl = GetIt.I;

Future<void> setupService() async {
  // sl.registerSingletonAsync<SharedPreferenceManager>(() async {
  //   final SharedPreferenceManager sharedPreferenceManager =
  //       SharedPreferenceManager();
  //   await sharedPreferenceManager.init();
  //   return sharedPreferenceManager;
  // });

  sl.registerSingleton<AuthRepositoryImpl>(AuthRepositoryImpl());
  sl.registerSingleton<ChangePasswordUseCase>(ChangePasswordUseCase());
  sl.registerSingleton<ForgotPasswordUseCase>(ForgotPasswordUseCase());
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<ChangeEmailUseCase>(ChangeEmailUseCase());

  await sl.allReady();
}
