import 'package:flutter/material.dart';

class LoadPage3 extends StatelessWidget{
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
              'assets/images/track_tt.png', // Replace with your asset image path
              height: 400,
              width: 400,
            ),

            // Title
            Text(
              'Get Bus Schedule of Your Route',
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
              'Users can easily access real-time bus schedules, ensuring they stay informed about arrival and departure times. Additionally, they can view detailed bus information, such as routes, stops, and availability, for a seamless commuting experience.',
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