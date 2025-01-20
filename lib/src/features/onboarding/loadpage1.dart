import 'package:flutter/material.dart';

class LoadPage1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 80) ,
      color: Colors.white, // Background color
      padding: const EdgeInsets.only(left: 16.0,right: 16.0),
      child:SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image or Icon
            Image.asset(
              'assets/images/schedule_tt.png', // Replace with your asset image path
              height: 400,
              width: 400,
            ),

            // Title
            Text(
              'Welcome to LU Assist!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),

            // Description
            Text(
              'Admins can publish posts, announcements, or updates through a dedicated interface, ensuring important information is effectively shared. Users can then access and read these posts seamlessly within a user-friendly news feed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

          ],
        ),
      ),
    );

  }

}