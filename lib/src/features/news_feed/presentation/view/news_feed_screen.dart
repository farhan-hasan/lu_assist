import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

import '../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../auth/data/model/user_model.dart';
import '../../../profile/presentation/view_model/profile_controller.dart';

class NewsFeedScreen extends ConsumerStatefulWidget {
  const NewsFeedScreen({super.key});
  static const route = '/news_feed_screen';

  static setRoute() => '/news_feed_screen';

  @override
  ConsumerState<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends ConsumerState<NewsFeedScreen> {
  final SharedPreferenceManager sharedPreferenceManager = sl.get<SharedPreferenceManager>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      initData();
    });
    super.initState();
  }

  initData() async {
    UserModel? userModel = await ref.read(profileProvider.notifier).readProfile(sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_UID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("NEWS FEED", style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),),
    );
  }
}
