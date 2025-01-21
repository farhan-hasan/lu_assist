import 'package:flutter/material.dart';

class LoadPage1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or Icon
          Image.asset(
            'assets/images/feed_tt.png', // Replace with your asset image path
            // height: 400,
            // width: 400,
          ),

          // Title
          Text(
            'Welcome to LU Assist!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),

          // Description
          Text(
            'Admins can publish posts, announcements, or updates through a dedicated interface, ensuring important information is effectively shared. Users can then access and read these posts seamlessly within a user-friendly news feed',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

        ],
      ),
    );

  }

}