import 'package:flutter/material.dart';

class LoadPage2 extends StatelessWidget{
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
              'lib/images/track_tt.png', // Replace with your asset image path
              height: 400,
              width: 400,
            ),

            // Title
            Text(
              'Track Your Own Route',
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
              'Users can mark a specific place with a "ping" to enable location-based tracking. This allows monitoring the number of individuals or activities occurring at that specific location in real time.',
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