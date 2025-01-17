
import 'package:get_it/get_it.dart';


final sl = GetIt.I;

Future<void> setupService() async {
  // sl.registerSingletonAsync<SharedPreferenceManager>(() async {
  //   final SharedPreferenceManager sharedPreferenceManager =
  //       SharedPreferenceManager();
  //   await sharedPreferenceManager.init();
  //   return sharedPreferenceManager;
  // });


  await sl.allReady();
}
