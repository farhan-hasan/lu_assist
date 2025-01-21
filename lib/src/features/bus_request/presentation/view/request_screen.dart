import 'package:flutter/material.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});
  static const route = '/request_screen';

  static setRoute() => '/request_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF433878),
        title: Image.asset(
          'images/lu_assist_logo.png',
          height: 50,

        ),

      ),
    );
  }
}