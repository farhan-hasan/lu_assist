import 'package:flutter/material.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});
  static const route = '/track_screen';

  static setRoute() => '/track_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Text("REQUEST PAGE", style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),),
    );
  }
}
