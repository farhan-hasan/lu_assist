import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const route = '/splash_screen';

  static setRoute() => '/splash_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Splash"),),
    );
  }
}
