import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';





















import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/core/utils/logger/logger.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view/create_schedule_screen.dart';

import '../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../core/utils/constants/enum.dart';
import '../../../../shared/data/model/bus_model.dart';
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../../shared/widgets/bus_card.dart';
import '../../../bus_schedule/presentation/view_model/schedule_controller.dart';






import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_request_schedule_screen.dart';

class RequestScreen extends StatefulWidget {
  static const route = '/request_screen';
  static setRoute() => '/request_screen';
  const RequestScreen({Key? key}) : super(key: key);


  @override
  _RequestScreenState createState() => _RequestScreenState();
}


class _RequestScreenState extends State<RequestScreen> with SingleTickerProviderStateMixin {
  final SharedPreferenceManager sharedPreferenceManager =
  sl.get<SharedPreferenceManager>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  String selectedTime = '10';
  bool isLoading = false;
  int numberOfRequests = 0;
  String selectedMinute= '00';
  String selectedMidDay='AM';
  List<String> minutes = ['00', '15', '30', '45'];
  List<String> midDays = ['AM', 'PM'];


  final List<String> times = ['Select Option','10', '11', '12', '1', '2', '3', '4'];
  ValueNotifier<List<BusModel>> busScheduleListener = ValueNotifier([]);
  ValueNotifier<Map<String, List<BusModel>>> groupedBusesListener =
  ValueNotifier({});



  @override
  void initState() {

    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }








//Submit Request
  Future<void> submitRequest(String route, String time ,String minuteTime,String midDayTime ) async {
    try {
      String currentUserId = sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_UID);


      DocumentReference docRef = firestore
          .collection('route')
          .doc(route.replaceAll('ROUTE', 'Route '))
          .collection('bus_request')
          .doc('$time:$minuteTime $midDayTime');


      // Fetch the current document
      final snapshot = await docRef.get();


      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        //int currentRequests = data['number_of_request'] ?? 0;
        List<dynamic> usersWhoRequested = data['users'] ?? [];


        // Check if the current user has already submitted a request
        if (usersWhoRequested.contains(currentUserId)) {
          BotToast.showText(
            text: "You have already submitted a request for $time:$minuteTime $midDayTime.",
            duration: const Duration(seconds: 2),
          );
          return;
        }


        // Prevent further requests if `number_of_request` is not 0 or 1
        // if (currentRequests != 0 && currentRequests != 1) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Requests are currently closed for $time.')),
        //   );
        //   return;
        // }


        // Allow request, increment `number_of_request`, and add user to the list
        await docRef.update({
          'number_of_request': FieldValue.increment(1),
          'users': FieldValue.arrayUnion([currentUserId]),
        });


        BotToast.showText(
          text: "'Request successfully submitted for $time:$minuteTime $midDayTime.",
          duration: const Duration(seconds: 2),
        );
      } else {
        // If the document doesn't exist, create it and allow the request
        await docRef.set({
          'number_of_request': 1,
          'users': [currentUserId], // Add the current user to the list
        });


        BotToast.showText(
          text: "Request successfully submitted for $time:$minuteTime $midDayTime.",
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      BotToast.showText(
        text: "Failed to submit request: $e.",
        duration: const Duration(seconds: 2),
      );

    }

  }



  //Reset button of Admin
  Future<void> resetRequests(String route, String time, String minuteTime, String midDayTime) async {
    try {
      DocumentReference docRef = firestore
          .collection('route')
          .doc(route.replaceAll('ROUTE', 'Route '))
          .collection('bus_request')
          .doc('$time:$minuteTime $midDayTime');


      final snapshot = await docRef.get();


      if (snapshot.exists) {
        // Reset number_of_request and clear users array
        await docRef.update({
          'number_of_request': 0,
          'users': [],
        });


        //debugPrint('Delete successfully done for $time:$minuteTime $midDayTime on $route');
        BotToast.showText(
          text: "Delete successfully done for $time:$minuteTime $midDayTime on $route.",
          duration: const Duration(seconds: 2),
        );

      } else {
       // debugPrint('No data found for the selected time.');
        BotToast.showText(
          text: "No data found for the selected time.",
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
     // debugPrint('Failed to reset data: $e');
      BotToast.showText(
        text: "Failed to reset data: $e.",
        duration: const Duration(seconds: 2),
      );
      rethrow; // Rethrow the exception to be handled in the UI
    }
  }







////Delete Approved Bus


  Future<void> deleteBusRequest(String? route, String? time, String? busNumber) async {
    try {
      // Delete bus from approved_bus collection
      QuerySnapshot approvedBusSnapshot = await FirebaseFirestore.instance
          .collection('route')
          .doc(route?.replaceAll('ROUTE', 'Route '))
          .collection('bus_request')
          .doc(time)
          .collection('approved_bus')
          .get();


      for (var busDoc in approvedBusSnapshot.docs) {
        final data = busDoc.data() as Map<String, dynamic>?;
        if (data != null && data['number'] == busNumber) {
          await busDoc.reference.delete();
          print("Bus with number $busNumber deleted successfully.");

          BotToast.showText(
            text: "Bus with number $busNumber deleted successfully.",
            duration: const Duration(seconds: 2),
          );


          break;
        }
      }





      // Set allocated field to false in the bus collection
      final busDoc = await firestore
          .collection('bus')
          .doc(busNumber)
          .get();

      if (busDoc.exists) {
        await firestore
            .collection('bus')
            .doc(busNumber)
            .update({
          'allocated': false,
        });
      }


      BotToast.showText(
        text: "Bus with number $busNumber deleted successfully.",
        duration: const Duration(seconds: 2),
      );

    } catch (e) {
      BotToast.showText(
        text: "Failed to delete bus request: $e",
        duration: const Duration(seconds: 2),
      );

    }
  }











  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/LU_Assist__LOGO.png',
            height: context.height * 0.20,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight * 1),
            child: Container(
              color: Colors.white,
              child: Center(
                child: Card(
                  //Tab Bar Design
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    splashFactory: NoSplash.splashFactory,
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: context.bodySmall,
                    dividerHeight: 0,
                    indicatorColor: primaryColor,
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: context.bodyExtraSmall,
                    labelColor: Colors.white,
                    dividerColor: Colors.white,
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Route 1'),
                      Tab(text: 'Route 2'),
                      Tab(text: 'Route 3'),
                      Tab(text: 'Route 4'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: sharedPreferenceManager.getValue(
            key: SharedPreferenceKeys.USER_ROLE) ==
            Role.admin.name
        //floatingActionButton for Admin To Make Request Schedule
            ? FloatingActionButton(
          onPressed: () {
            context.push(CreateRequestScheduleScreen.route,
              extra: (bool isSuccess) {
                if (isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Schedule created successfully!')),
                  );
                }
              },
            );
          },
          child: Icon(Icons.add),

        ) : null,





        body: TabBarView(
          controller: _tabController,
          children: ['ROUTE1', 'ROUTE2', 'ROUTE3', 'ROUTE4'].map((route) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hours:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: 200,
                        //Hours Dropdown
                        child: DropdownButtonFormField<String>(
                          value: selectedTime,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTime = newValue!;
                            });
                          },
                          decoration: const InputDecoration(

                            border: OutlineInputBorder(),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: times
                              .map((time) => DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          ))
                              .toList(),
                        ),

                      ),
                    ],
                  ),
                  const SizedBox(height:8 ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Minutes:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 5),

                      SizedBox(
                        width: 200,
                        //DropDown For Minutes
                        child: DropdownButtonFormField<String>(
                          value: selectedMinute,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMinute = newValue!;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: minutes
                              .map((minuteTime) => DropdownMenuItem<String>(
                            value: minuteTime,
                            child: Text(minuteTime),
                          ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mid Day:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<String>(
                          value: selectedMidDay,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMidDay = newValue!;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: midDays
                              .map((midDayTime) => DropdownMenuItem<String>(
                            value: midDayTime,
                            child: Text(midDayTime),
                          ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),



                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 45),
                      //Button To Submit Request
                      ElevatedButton(
                        onPressed: () => submitRequest(route, selectedTime,selectedMinute,selectedMidDay),
                        child: Text('Request'),
                      ),
                     ],
                  ),
                  const SizedBox(height: 8),






                    Column(

                      children: [
                        //Number Of Requests
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: firestore
                              .collection('route')
                              .doc(route.replaceAll('ROUTE', 'Route '))
                              .collection('bus_request')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.hasData) {
                              final busRequests = snapshot.data!.docs;

                              // List to hold the requested times and their number of requests
                              List<Widget> requestItems = [];
                              for (var busRequest in busRequests) {
                                final requestData = busRequest.data();
                                final requestedTime = busRequest
                                    .id; // This will be the doc ID, which corresponds to the time
                                final numberOfRequests = requestData['number_of_request'] ??
                                    0;

                                // Add the item to the list
                                if(numberOfRequests>0){
                                requestItems.add(
                                  sharedPreferenceManager.getValue(
                                      key: SharedPreferenceKeys.USER_ROLE) ==
                                      Role.admin.name?
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      width: 150,
                                      height: 150,



                                      //Long Press Delete On Request Card

                                      child: GestureDetector(
                                        onLongPress: () {
                                          DateFormat dateFormat = DateFormat('h:mm a');
                                          DateTime dateTime = dateFormat.parse(requestedTime);
                                          String hours = DateFormat('h').format(dateTime);
                                          String minutes = DateFormat('mm').format(dateTime);
                                          String midDay = DateFormat('a').format(dateTime);

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: const Text('Do you want to delete this request?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog without action
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await resetRequests(route, hours, minutes, midDay);
                                                        Navigator.of(context).pop(); // Close the dialog on success
                                                        // ScaffoldMessenger.of(context).showSnackBar(
                                                        //   const SnackBar(content: Text('Requests have been reset successfully')),
                                                        // );

                                                        BotToast.showText(
                                                          text: "Requests have been deleted successfully",
                                                          duration: const Duration(seconds: 2),
                                                        );
                                                      } catch (e) {
                                                        Navigator.of(context).pop(); // Close the dialog on error
                                                        // ScaffoldMessenger.of(context).showSnackBar(
                                                        //   SnackBar(content: Text('Error: $e')),
                                                        // );
                                                        BotToast.showText(
                                                          text: "Error: $e",
                                                          duration: const Duration(seconds: 2),
                                                        );

                                                      }
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  requestedTime,
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Requests: $numberOfRequests',
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    DateFormat dateFormat = DateFormat('h:mm a');
                                                    DateTime dateTime = dateFormat.parse(requestedTime);
                                                    String hours = DateFormat('h').format(dateTime);
                                                    String minutes = DateFormat('mm').format(dateTime);
                                                    String midDay = DateFormat('a').format(dateTime);
                                                    submitRequest(route, hours, minutes, midDay);
                                                  },
                                                  child: const Text('Request'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )

                                    ),

                                ):Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            requestedTime,
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Requests: $numberOfRequests',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          ElevatedButton(
                                            onPressed: () {
                                              DateFormat dateFormat = DateFormat('h:mm a');
                                              DateTime dateTime = dateFormat.parse(requestedTime);
                                              String hours = DateFormat('h').format(dateTime);
                                              String minutes = DateFormat('mm').format(dateTime);
                                              String midDay = DateFormat('a').format(dateTime);
                                              submitRequest(route, hours, minutes, midDay);
                                            },
                                            child: const Text('Request'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                                else{const SizedBox.shrink();}
                              }

                              // Horizontal ListView displaying the requested times and their counts
                              return SizedBox(
                                height: 150,
                                child: requestItems.isNotEmpty
                                    ? ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: requestItems,
                                )
                                    : Center(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.all(20),
                                      child: const Text(
                                        'No requests available',
                                        style: TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              );

                            }
                            else{const SizedBox.shrink();}

                            return const Center(child: Text('No data available'));
                          },
                        ),





                        const SizedBox(height: 8),





                    //Card Load of Approved busses When Admin Makes it
                         Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             //Creates Card For Approved busses
                             StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                               stream: FirebaseFirestore.instance
                                   .collection('route')
                                   .doc(route.replaceAll('ROUTE', 'Route '))
                                   .collection('bus_request')
                                   .snapshots(),
                               builder: (context, snapshot) {
                                 if (snapshot.connectionState == ConnectionState.waiting) {
                                   return const Center(child: CircularProgressIndicator());
                                 }

                                 if (snapshot.hasError) {
                                   return Text('Error: ${snapshot.error}');
                                 }

                                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                   return const Text('No requests found');
                                 }

                                 final requestDocs = snapshot.data!.docs;

                                 List<Widget> requestCards = [];
                                 for (var requestDoc in requestDocs) {
                                   final requestTimeId = requestDoc.id;

                                   requestCards.add(
                                     StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                       stream: FirebaseFirestore.instance
                                           .collection('route')
                                           .doc(route.replaceAll('ROUTE', 'Route '))
                                           .collection('bus_request')
                                           .doc(requestTimeId)
                                           .collection('approved_bus')
                                           .snapshots(),
                                       builder: (context, busSnapshot) {
                                         if (busSnapshot.connectionState == ConnectionState.waiting) {
                                           return const SizedBox.shrink();
                                         }

                                         if (busSnapshot.hasError) {
                                           return Text('Error fetching approved buses: ${busSnapshot.error}');
                                         }

                                         if (!busSnapshot.hasData || busSnapshot.data!.docs.isEmpty) {
                                           return const SizedBox.shrink();
                                         }

                                         final buses = busSnapshot.data!.docs;
                                         return ListView.builder(
                                           shrinkWrap: true,
                                           physics: const NeverScrollableScrollPhysics(),
                                           itemCount: buses.length,
                                           itemBuilder: (context, index) {
                                             final busData = buses[index].data();
                                             final busModel = BusModel.fromJson(busData);

                                             return Card(
                                               elevation: 4,
                                               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                               shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(16),
                                               ),
                                               child: Padding(
                                                 padding: const EdgeInsets.all(8.0),
                                                 child: Row(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     busModel.image != null
                                                         ? ClipRRect(
                                                       borderRadius: BorderRadius.circular(8),
                                                       child: Image.network(
                                                         busModel.image!,
                                                         width: 60,
                                                         height: 60,
                                                         fit: BoxFit.cover,
                                                         errorBuilder: (context, error, stackTrace) {
                                                           return const Icon(Icons.directions_bus, size: 60);
                                                         },
                                                       ),
                                                     )
                                                         : const Icon(Icons.directions_bus, size: 60),
                                                     const SizedBox(width: 16),
                                                     Expanded(
                                                       child: Column(
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           Text(
                                                             busModel.number ?? 'Bus Number not available',
                                                             style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                               fontWeight: FontWeight.bold,
                                                             ),
                                                           ),
                                                           const SizedBox(height: 4),
                                                           Text(
                                                             'Route: ${busModel.route}',
                                                             style: Theme.of(context).textTheme.bodyMedium,
                                                           ),
                                                           Text(
                                                             'Time: ${busModel.time}',
                                                             style: Theme.of(context).textTheme.bodyMedium,
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                     sharedPreferenceManager.getValue(
                                                         key: SharedPreferenceKeys.USER_ROLE) ==
                                                         Role.admin.name
                                                         ? IconButton(
                                                       icon: const Icon(Icons.delete, color: Colors.red),
                                                       onPressed: () {
                                                         deleteBusRequest(busModel.route, busModel.time, busModel.number);
                                                       },
                                                     )
                                                         : const SizedBox.shrink(),
                                                   ],
                                                 ),
                                               ),
                                             );
                                           },
                                         );
                                       },
                                     ),
                                   );
                                 }

                                 return ListView(
                                   shrinkWrap: true,
                                   children: requestCards,
                                 );
                               },
                             )
                           ],
                         ),








                      ],
                    ),

                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}





























