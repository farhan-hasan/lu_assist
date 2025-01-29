
  //static const route = '/Create_Request_Schedule_Screen';
  //static setRoute() => '/Create_Request_Schedule_Screen';
  //
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class CreateRequestScheduleScreen extends StatefulWidget {
//   CreateRequestScheduleScreen({super.key,required this.onCreate});
//   static const route = '/Create_Request_Schedule_Screen';
//   static setRoute() => '/Create_Request_Schedule_Screen';
//   late final Function(bool isSuccess) onCreate;
//
//     @override
//     _CreateRequestScheduleScreen createState() => _CreateRequestScheduleScreen();
//   }
//
//   class _CreateRequestScheduleScreen extends State<CreateRequestScheduleScreen> {
//     String? selectedRoute;
//     String? selectedDay;
//     String? selectedHour;
//     String? selectedMinute;
//     String? selectedMidDay;
//     String? selectedDestination;
//     String? selectedBus;
//
//     List<String> routes = ['Route 1', 'Route 2', 'Route 3'];
//     List<String> days = ['Monday', 'Tuesday', 'Wednesday'];
//     List<String> hours = ['1', '2', '3', '4', '5'];
//     List<String> minutes = ['00', '15', '30', '45'];
//     List<String> midDays = ['AM', 'PM'];
//     List<String> destinations = ['Destination 1', 'Destination 2'];
//     List<String> buses = [];
//
//     @override
//     void initState() {
//       super.initState();
//       fetchBuses();
//     }
//
//     Future<void> fetchBuses() async {
//       try {
//         final busSnapshot = await FirebaseFirestore.instance
//             .collection('bus')
//             .where('allocated', isEqualTo: false)
//             .get();
//
//         final List<String> busList =
//         busSnapshot.docs.map((doc) => doc.data()['number'] as String).toList();
//
//         setState(() {
//           buses = busList;
//         });
//       } catch (e) {
//         print('Error fetching buses: $e');
//       }
//     }
//
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Request Schedule')),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               buildDropdown(
//                 labelText: 'Route',
//                 value: selectedRoute,
//                 items: routes,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedRoute = value;
//                   });
//                 },
//               ),
//               buildDropdown(
//                 labelText: 'Day',
//                 value: selectedDay,
//                 items: days,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedDay = value;
//                   });
//                 },
//               ),
//               buildDropdown(
//                 labelText: 'Hour',
//                 value: selectedHour,
//                 items: hours,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedHour = value;
//                   });
//                 },
//               ),
//               buildDropdown(
//                 labelText: 'Minute',
//                 value: selectedMinute,
//                 items: minutes,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedMinute = value;
//                   });
//                 },
//               ),
//               buildDropdown(
//                 labelText: 'Mid Day',
//                 value: selectedMidDay,
//                 items: midDays,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedMidDay = value;
//                   });
//                 },
//               ),
//               buildDropdown(
//                 labelText: 'Destination',
//                 value: selectedDestination,
//                 items: destinations,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedDestination = value;
//                   });
//                 },
//               ),
//               buildDropdown(
//                 labelText: 'Bus',
//                 value: selectedBus,
//                 items: buses,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedBus = value;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     Widget buildDropdown({
//       required String labelText,
//       required String? value,
//       required List<String> items,
//       required ValueChanged<String?> onChanged,
//     }) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: DropdownButtonFormField<String>(
//           decoration: InputDecoration(
//             labelText: labelText,
//             border: const OutlineInputBorder(),
//           ),
//           value: value,
//           dropdownColor: Colors.white,
//           items: items
//               .map((item) => DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           ))
//               .toList(),
//           onChanged: onChanged,
//         ),
//       );
//     }
//   }








































  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/data/model/bus_model.dart';


  class CreateRequestScheduleScreen extends StatefulWidget {
    CreateRequestScheduleScreen({super.key,required this.onCreate});
    static const route = '/Create_Request_Schedule_Screen';
    static setRoute() => '/Create_Request_Schedule_Screen';
    late final Function(bool isSuccess) onCreate;
    @override
    _CreateRequestScheduleScreen createState() => _CreateRequestScheduleScreen();
  }

  class _CreateRequestScheduleScreen extends State<CreateRequestScheduleScreen> {
    String? selectedRoute;
    String? selectedDay;
    String? selectedHour;
    String? selectedMinute;
    String? selectedMidDay;
    String? selectedDestination;
    String? selectedBus;

    List<String> routes = ['Route 1', 'Route 2', 'Route 3','Route 4'];
    List<String> days = ['Monday', 'Tuesday', 'Wednesday'];
    List<String> hours = ['1', '2', '3', '4', '5','10'];
    List<String> minutes = ['00', '15', '30', '45'];
    List<String> midDays = ['AM', 'PM'];
    List<String> destinations = ['Home', 'University'];
    List<String> buses = [];

    @override
    void initState() {
      super.initState();
      fetchBuses();
    }

    Future<void> fetchBuses() async {
      try {
        final busSnapshot = await FirebaseFirestore.instance
            .collection('bus')
            .where('allocated', isEqualTo: false)
            .get();

        final List<String> busList =
        busSnapshot.docs.map((doc) => doc.data()['number'] as String).toList();

        setState(() {
          buses = busList;
        });
      } catch (e) {
        print('Error fetching buses: $e');
      }
    }

    Future<void> submitApprovedBus() async {
      if (selectedBus != null &&
          selectedRoute != null &&
          selectedDay != null &&
          selectedHour != null &&
          selectedMinute != null &&
          selectedMidDay != null &&
          selectedDestination != null) {
        try {
          final busRef = FirebaseFirestore.instance.collection('route')
              .doc(selectedRoute)
              .collection('bus_request')
              .doc('$selectedHour:$selectedMinute $selectedMidDay')
              .collection('approved_bus')
              .doc();
          final busDoc = await FirebaseFirestore.instance
              .collection('bus')
              .doc(selectedBus)
              .get();

          // Create a BusModel instance with selected data
          BusModel approvedBus = BusModel(
            number: selectedBus,
            route: selectedRoute,
            day: selectedDay,
            time: '$selectedHour:$selectedMinute $selectedMidDay',
            allocated: true,
            type: busDoc.data()?['type'] ?? 'N/A',
            image: busDoc.data()?['image'] ?? 'N/A',

          );

          // Save to approved_bus collection
          await busRef.set(approvedBus.toJson());

          // Set 'allocated' field of the selected bus to true
          await FirebaseFirestore.instance
              .collection('bus')
              .doc(selectedBus)
              .update({'allocated': true});

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Bus successfully approved and allocated!'),
          ));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error approving bus: $e'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select all the required fields'),
        ));
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bus Approval')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildDropdown(
                labelText: 'Route',
                value: selectedRoute,
                items: routes,
                onChanged: (value) {
                  setState(() {
                    selectedRoute = value;
                  });
                },
              ),
              buildDropdown(
                labelText: 'Day',
                value: selectedDay,
                items: days,
                onChanged: (value) {
                  setState(() {
                    selectedDay = value;
                  });
                },
              ),
              buildDropdown(
                labelText: 'Hour',
                value: selectedHour,
                items: hours,
                onChanged: (value) {
                  setState(() {
                    selectedHour = value;
                  });
                },
              ),
              buildDropdown(
                labelText: 'Minute',
                value: selectedMinute,
                items: minutes,
                onChanged: (value) {
                  setState(() {
                    selectedMinute = value;
                  });
                },
              ),
              buildDropdown(
                labelText: 'Mid Day',
                value: selectedMidDay,
                items: midDays,
                onChanged: (value) {
                  setState(() {
                    selectedMidDay = value;
                  });
                },
              ),
              buildDropdown(
                labelText: 'Destination',
                value: selectedDestination,
                items: destinations,
                onChanged: (value) {
                  setState(() {
                    selectedDestination = value;
                  });
                },
              ),
              buildDropdown(
                labelText: 'Bus',
                value: selectedBus,
                items: buses,
                onChanged: (value) {
                  setState(() {
                    selectedBus = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitApprovedBus,
                child: const Text('Approve and Allocate Bus'),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildDropdown({
      required String labelText,
      required String? value,
      required List<String> items,
      required ValueChanged<String?> onChanged,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Sets the background color to white
          ),
          value: value,
          items: items
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white, // Ensures the dropdown menu is also white
        ),
      );
    }
  }
