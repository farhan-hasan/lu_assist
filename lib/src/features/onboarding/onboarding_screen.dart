import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/features/auth/presentation/login/view/login_screen.dart';
import 'package:lu_assist/src/features/onboarding/loadpage1.dart';
import 'package:lu_assist/src/features/onboarding/loadpage2.dart';
import 'package:lu_assist/src/features/onboarding/loadpage3.dart';
import 'package:lu_assist/src/features/onboarding/loadpage4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../auth/presentation/signup/view/signup_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  static const route = '/onboarding';

  static setRoute() => '/onboarding';
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
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
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(3);
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                SmoothPageIndicator(controller: _controller, count: 4),
                lastPage
                    ? GestureDetector(
                  onTap: ()  {

                    context.go(LoginScreen.route);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
