
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:lu_assist/src/core/notification/local_notification/local_notification_handler.dart';
import 'package:lu_assist/src/core/notification/push_notification/push_notification_handler.dart';

import '../../../firebase_options.dart';
import '../../core/database/local/shared_preference/shared_preference_manager.dart';


final sl = GetIt.I;

Future<void> setupService() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  sl.registerSingletonAsync<SharedPreferenceManager>(() async {
    final SharedPreferenceManager sharedPreferenceManager =
    SharedPreferenceManager();
    await sharedPreferenceManager.init();
    return sharedPreferenceManager;
  });

  LocalNotificationHandler();
  PushNotificationHandler();

  await sl.allReady();
}
