import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/database/local/shared_preference/shared_preference_manager.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/features/auth/presentation/login/view/login_screen.dart';
import 'package:lu_assist/src/features/news_feed/presentation/view/news_feed_screen.dart';
import 'package:lu_assist/src/features/onboarding/loadpage1.dart';
import 'package:lu_assist/src/features/onboarding/loadpage2.dart';
import 'package:lu_assist/src/features/onboarding/loadpage3.dart';
import 'package:lu_assist/src/features/onboarding/loadpage4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../core/router/router.dart';
import '../../shared/dependency_injection/dependency_injection.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  @override
  static const route = '/onboarding';

  static setRoute() => '/onboarding';
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final SharedPreferenceManager sharedPreferenceManager = sl.get<SharedPreferenceManager>();
  @override
  void initState() {
    super.initState();
  }
  final PageController _controller = PageController();
  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  lastPage = (index == 3);
                });
              },
              children: [
                LoadPage1(),
                LoadPage2(),
                LoadPage3(),
                LoadPage4(),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmoothPageIndicator(
                    effect:  const WormEffect(
                        activeDotColor:  primaryColor
                    ),

                    controller: _controller, count: 4,),
                  ElevatedButton(onPressed: () {
                    bool isLogged = sharedPreferenceManager.getValue(
                        key: SharedPreferenceKeys.AUTH_STATE) ??
                        false;
                    if (!isLogged) {
                      ref.read(goRouterProvider).go(LoginScreen.route);
                    } else {
                      ref.read(goRouterProvider).go(
                        NewsFeedScreen.route,
                      );
                    }
                  }, child: Container(
                      width: double.infinity,
                      child: Center(child: Text("Get Started"))))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
