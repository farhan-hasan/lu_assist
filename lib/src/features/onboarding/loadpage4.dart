import 'package:flutter/material.dart';

class LoadPage4 extends StatelessWidget{
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
              'assets/images/request_tt.png', // Replace with your asset image path
              height: 400,
              width: 400,
            ),

            // Title
            Text(
              'Request for Bus When Needed',
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
              'Users can submit requests for a bus at their preferred time directly through the app, ensuring convenience and flexibility. The system processes these requests and schedules buses accordingly to meet user needs.',
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