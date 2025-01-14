import 'package:lu_assist/src/features/auth/presentation/logout/view_model/logout_generic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logoutProvider = StateNotifierProvider<LogoutController, LogoutGeneric>(
    (ref) => LogoutController(ref));

class LogoutController extends StateNotifier<LogoutGeneric> {
  LogoutController(this.ref) : super(LogoutGeneric());
  Ref ref;

  Future<bool> logout() async {
    return true;
  }
}
