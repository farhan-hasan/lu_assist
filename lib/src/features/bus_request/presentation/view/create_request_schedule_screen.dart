
  //static const route = '/Create_Request_Schedule_Screen';
  //static setRoute() => '/Create_Request_Schedule_Screen';
  //
  import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

import '../../../../core/utils/logger/logger.dart';
import '../../../../shared/data/data_source/fcm_remote_data_source.dart';
import '../../../../shared/data/model/push_body_model.dart';
import '../../../bus_list/data/model/bus_model.dart';



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
    final formKey = GlobalKey<FormState>();

    List<String> routes = ["Select Option",
      "Route 1",
      "Route 2",
      "Route 3",
      "Route 4"];
    List<String> days = ["Select Option",
      "Saturday",
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday"];
    List<String> hours = ["Select Option",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12"];
    List<String> minutes = ["Select Option", '00', '15', '30', '45'];
    List<String> midDays = ["Select Option", 'AM', 'PM'];
    List<String> destinations = ["Select Option", 'Home', 'University'];
    List<String> buses = ["Select Option", ];

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
          selectedHour != null &&
          selectedMinute != null &&
          selectedMidDay != null) {
        try {
          final busRef = FirebaseFirestore.instance.collection('route')
              .doc(selectedRoute?.replaceAll(' ', '').toUpperCase())
              .collection('approved_bus')
              .doc();
          final busDoc = await FirebaseFirestore.instance
              .collection('bus')
              .doc(selectedBus)
              .get();

          String arrivalPoint = "";
          switch(selectedRoute) {
            case "Route 1" : arrivalPoint = "Tilagor";
            case "Route 2" : arrivalPoint = "Shurma Tower";
            case "Route 3" : arrivalPoint = "Lakkatura";
            case "Route 4" : arrivalPoint = "Tilagor";
          }


          String time =
              "$selectedHour:$selectedMinute $selectedMidDay";
          time = time.replaceAll(RegExp(r'[^\w:APM ]'), '').trim();
          RegExp timeRegex = RegExp(r'(\d+):(\d+)\s*(AM|PM)');
          Match? match = timeRegex.firstMatch(time);
          DateTime result = DateTime.now();
          if (match != null) {
            int hour = int.parse(match.group(1)!); // Extract hour
            int minute = int.parse(match.group(2)!); // Extract minute

            // Get the current date
            DateTime now = DateTime.now();

            // Combine the current date with the parsed time
            result = DateTime(now.year, now.month, now.day, hour, minute);

            debug(result); // Example Output: 2025-01-25 08:15:00.000
          } else {
            debug("Failed to parse time string.");
          }

          // Create a BusModel instance with selected data
          BusModel approvedBus = BusModel(
            number: selectedBus,
            route: selectedRoute,
            day: "",
            time: '$selectedHour:$selectedMinute $selectedMidDay',
            allocated: true,
            type: busDoc.data()?['type'] ?? '',
            image: busDoc.data()?['image'] ?? '',
            arrivalPoint:arrivalPoint,
            arrivalTime: result,
            incoming: false
          );

          // Save to approved_bus collection
          await busRef.set(approvedBus.toJson());

          // Set 'allocated' field of the selected bus to true
          await FirebaseFirestore.instance
              .collection('bus')
              .doc(selectedBus)
              .update({'allocated': true});

          FCMRemoteDataSource fcmRemoteDataSource = FCMRemoteDataSource();
          fcmRemoteDataSource.sendPushMessage(
              topic: "bus_request",
              title: "New bus assigned",
              body: "A bus has been assigned on $selectedRoute at $selectedHour:$selectedMinute $selectedMidDay",
              data: PushBodyModel(type: "bus_request_approval", showNotification: true));

          context.pop();

          BotToast.showText(text: 'Bus successfully approved and allocated!');
        } catch (e) {
          BotToast.showText(text: 'Error approving bus: $e');
        }
      } else {
        BotToast.showText(text: 'Please select all the required fields');
      }
    }

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Bus Approval')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
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
                  // buildDropdown(
                  //   labelText: 'Day',
                  //   value: selectedDay,
                  //   items: days,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedDay = value;
                  //     });
                  //   },
                  // ),
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
                  // buildDropdown(
                  //   labelText: 'Destination',
                  //   value: selectedDestination,
                  //   items: destinations,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedDestination = value;
                  //     });
                  //   },
                  // ),
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
                  const SizedBox(height: 8),
                  SizedBox(
                    width: context.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                          submitApprovedBus();
                        }
                      },
                      child: const Text('Approve and Allocate Bus'),
                    ),
                  ),
                ],
              ),
            ),
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
          validator: (value) {
            if (value == "Select Option" || value == null) {
              return "Please select $labelText";
            }
            return null;
          },
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
