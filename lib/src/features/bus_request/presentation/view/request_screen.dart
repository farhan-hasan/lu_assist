import 'package:flutter/material.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});
  static const route = '/request_screen';

  static setRoute() => '/request_screen';
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF433878),
        title: Image.asset(
          'assets/images/LU_Assist__LOGO.png',
          height: screenSize.height * 0.20,
        ),

      ),
    );
  }
}