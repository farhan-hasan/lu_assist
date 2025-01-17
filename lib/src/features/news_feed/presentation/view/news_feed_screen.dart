import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});
  static const route = '/news_feed_screen';

  static setRoute() => '/news_feed_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("NEWS FEED", style: context.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),),
    );
  }
}
