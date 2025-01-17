import 'package:flutter/material.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});
  static const route = '/schedule_screen';

  static setRoute() => '/schedule_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Text("SCHEDULE PAGE", style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),),
    );
  }
}
