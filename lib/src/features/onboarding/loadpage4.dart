import 'package:flutter/material.dart';

class LoadPage4 extends StatelessWidget{
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
            'assets/images/request_tt.png', // Replace with your asset image path
            // height: 400,
            // width: 400,
          ),

          // Title
          Text(
            'Request for Bus When Needed',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),

          // Description
          Text(
            "Users can submit requests for a bus at their preferred time directly through the app, ensuring convenience and flexibility. The system processes these requests and schedules buses accordingly to meet user needs.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

        ],
      ),
    );
  }

}