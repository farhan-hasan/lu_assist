import 'package:flutter/material.dart';

class LoadPage3 extends StatelessWidget{
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
            'assets/images/schedule_tt.png', // Replace with your asset image path
            // height: 400,
            // width: 400,
          ),

          // Title
          Text(
            'Get Bus Schedule of Your Route',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),

          // Description
          Text(
            "Users can easily access real-time bus schedules, ensuring they stay informed about arrival and departure times. Additionally, they can view detailed bus information, such as routes, stops, and availability, for a seamless commuting experience.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

        ],
      ),
    );
  }

}