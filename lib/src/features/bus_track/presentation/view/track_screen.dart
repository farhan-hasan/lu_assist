import 'package:flutter/material.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});
  static const route = '/request_screen';

  static setRoute() => '/request_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Text("REQUEST PAGE", style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),),
    );
  }
}
