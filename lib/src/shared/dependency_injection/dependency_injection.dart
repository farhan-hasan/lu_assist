
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

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

  await sl.allReady();
}
