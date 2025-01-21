import 'package:flutter/material.dart';

class LoadPage2 extends StatelessWidget{
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
            'assets/images/track_tt.png', // Replace with your asset image path
            // height: 400,
            // width: 400,
          ),

          // Title
          Text(
            'Track Your Own Route',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),

          // Description
          Text(
            "Users can mark a specific place with a ping to enable location-based tracking. This allows monitoring the number of individuals or activities occurring at that specific location in real time.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

        ],
      ),
    );
  }

}