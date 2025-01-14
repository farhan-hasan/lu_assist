import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const route = '/home_screen';

  static setRoute() => '/home_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("HOME PAGE", style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),),
    );
  }
}
