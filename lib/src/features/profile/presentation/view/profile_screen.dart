import 'package:flutter/material.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const route = '/profile_screen';

  static setRoute() => '/profile_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Text("PROFILE PAGE", style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),),
    );
  }
}
