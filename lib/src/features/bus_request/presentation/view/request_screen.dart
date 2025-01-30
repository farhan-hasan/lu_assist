import 'dart:core';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/core/utils/logger/logger.dart';
import 'package:lu_assist/src/shared/data/data_source/fcm_remote_data_source.dart';
import 'package:lu_assist/src/shared/data/model/push_body_model.dart';

import '../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../core/global/global_variables.dart';
import '../../../../core/utils/constants/enum.dart';
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../bus_list/data/model/bus_model.dart';
import 'create_request_schedule_screen.dart';

class RequestScreen extends StatefulWidget {
  static const route = '/request_screen';

  static setRoute() => '/request_screen';

  const RequestScreen({Key? key}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  final SharedPreferenceManager sharedPreferenceManager =
      sl.get<SharedPreferenceManager>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  String selectedTime = 'Select Option';
  bool isLoading = false;
  int numberOfRequests = 0;
  String selectedMinute = 'Select Option';
  String selectedMidDay = 'Select Option';
  String selectedRoute = 'Route 1';
  List<String> minutes = ['Select Option', '00', '15', '30', '45'];
  List<String> midDays = ['Select Option', 'AM', 'PM'];
  List<String> routes = ['Route 1', 'Route 2', 'Route 3', 'Route 4'];

  final List<String> times = [
    'Select Option',
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
    "12"
  ];
  ValueNotifier<List<BusModel>> busScheduleListener = ValueNotifier([]);
  ValueNotifier<Map<String, List<BusModel>>> groupedBusesListener =
      ValueNotifier({});

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

//Submit Request
  Future<void> submitRequest(
      String route, String time, String minuteTime, String midDayTime) async {
    try {
      String currentUserId =
          sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_UID);

      DocumentReference docRef = firestore
          .collection('route')
          .doc(route.replaceAll(' ', '').toUpperCase())
          .collection('bus_request')
          .doc('$time:$minuteTime$midDayTime');

      // Fetch the current document
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        //int currentRequests = data['number_of_request'] ?? 0;
        List<dynamic> usersWhoRequested = data['users'] ?? [];

        // Check if the current user has already submitted a request
        if (usersWhoRequested.contains(currentUserId)) {
          BotToast.showText(
            text:
                "You have already submitted a request for $time:$minuteTime $midDayTime.",
            duration: const Duration(seconds: 2),
          );
          return;
        }

        // Allow request, increment `number_of_request`, and add user to the list
        await docRef.update({
          'number_of_request': FieldValue.increment(1),
          'users': FieldValue.arrayUnion([currentUserId]),
        });

        BotToast.showText(
          text:
              "'Request successfully submitted for $time:$minuteTime $midDayTime.",
          duration: const Duration(seconds: 2),
        );

        FCMRemoteDataSource fcmRemoteDataSource = FCMRemoteDataSource();
        fcmRemoteDataSource.sendPushMessage(
            topic: "bus_request",
            title: "Someone is requesting a bus",
            body: "A bus request has been placed for $selectedRoute",
            data: PushBodyModel(type: "bus_request", showNotification: true));
      } else {
        // If the document doesn't exist, create it and allow the request
        await docRef.set({
          'number_of_request': 1,
          'users': [currentUserId], // Add the current user to the list
        });

        BotToast.showText(
          text:
              "Request successfully submitted for $time:$minuteTime $midDayTime.",
          duration: const Duration(seconds: 2),
        );

        FCMRemoteDataSource fcmRemoteDataSource = FCMRemoteDataSource();
        fcmRemoteDataSource.sendPushMessage(
            topic: "bus_request",
            title: "Someone is requesting a bus",
            body: "A bus request has been placed for $selectedRoute",
            data: PushBodyModel(type: "bus_request", showNotification: true));
      }
    } catch (e) {
      BotToast.showText(
        text: "Failed to submit request: $e.",
        duration: const Duration(seconds: 2),
      );
    }
  }

  //Reset button of Admin
  Future<void> resetRequests(String route) async {
    try {
      CollectionReference busRequestCollection = firestore
          .collection('route')
          .doc(route.replaceAll(' ', '').toUpperCase())
          .collection('bus_request');

      // Get all documents in the bus_request collection
      final snapshot = await busRequestCollection.get();

      if (snapshot.docs.isNotEmpty) {
        // Delete each document
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        BotToast.showText(
          text: "All requests deleted successfully for route $route.",
          duration: const Duration(seconds: 2),
        );
      } else {
        BotToast.showText(
          text: "No requests found for the selected route.",
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      BotToast.showText(
        text: "Failed to reset data: $e.",
        duration: const Duration(seconds: 2),
      );
      rethrow;
    }
  }

  Future<void> deleteRequest(
      String route, String time, String minuteTime, String midDayTime) async {
    try {
      DocumentReference docRef = firestore
          .collection('route')
          .doc(route.replaceAll(' ', '').toUpperCase())
          .collection('bus_request')
          .doc('$time:$minuteTime$midDayTime');

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        // Reset number_of_request and clear users array
        await docRef.delete();

        //debugPrint('Delete successfully done for $time:$minuteTime $midDayTime on $route');
        BotToast.showText(
          text:
              "Delete successfully done for $time:$minuteTime $midDayTime on $route.",
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

  Future<void> deleteApprovedBus(
      String? route, String? time, String? busNumber) async {
    try {
      // Delete bus from approved_bus collection
      QuerySnapshot approvedBusSnapshot = await FirebaseFirestore.instance
          .collection('route')
          .doc(route?.replaceAll(' ', '').toUpperCase())
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
      final busDoc = await firestore.collection('bus').doc(busNumber).get();

      if (busDoc.exists) {
        await firestore.collection('bus').doc(busNumber).update({
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

  late Stream<QuerySnapshot<Map<String, dynamic>>> routeStream;

  Stream<QuerySnapshot<Map<String, dynamic>>> getBusRequestStream() {
    routeStream = firestore
        .collection('route')
        .doc(selectedRoute.replaceAll(' ', '').toUpperCase())
        .collection('bus_request')
        .snapshots();
    return routeStream;
  }

  Stream<List<BusModel>> getApprovedBusStream() {
    Stream<List<BusModel>> approvedBusStream = FirebaseFirestore.instance
        .collection('route')
        .doc(selectedRoute.replaceAll(' ', '').toUpperCase())
        .collection('approved_bus')
        .snapshots()
        .map((documentList) {
      return documentList.docs.map((r) => BusModel.fromJson(r.data())).toList();
    });
    return approvedBusStream;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Bus Request"),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight * 1),
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Card(
                    //Tab Bar Design
                    child: TabBar(
                      onTap: (value) {
                        if (selectedRoute == routes[_tabController.index]) {
                          return;
                        }

                        selectedRoute = routes[_tabController.index];
                        debug(selectedRoute);
                        setState(() {});
                      },
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
            actions: [
              if (sharedPreferenceManager.getValue(
                      key: SharedPreferenceKeys.USER_ROLE) ==
                  Role.admin.name)
                IconButton(
                    onPressed: () {
                      context.push(
                        CreateRequestScheduleScreen.route,
                        extra: (bool isSuccess) {
                          if (isSuccess) {
                            BotToast.showText(
                                text: 'Schedule created successfully!');
                          }
                        },
                      );
                    },
                    icon: Icon(Icons.add))
            ],
          ),
          // floatingActionButton: sharedPreferenceManager.getValue(
          //             key: SharedPreferenceKeys.USER_ROLE) ==
          //         Role.admin.name
          //     //floatingActionButton for Admin To Make Request Schedule
          //     ? FloatingActionButton(
          //         onPressed: () {
          //           context.push(
          //             CreateRequestScheduleScreen.route,
          //             extra: (bool isSuccess) {
          //               if (isSuccess) {
          //                 BotToast.showText(
          //                     text: 'Schedule created successfully!');
          //               }
          //             },
          //           );
          //         },
          //         child: Icon(Icons.add),
          //       )
          //     : null,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (sharedPreferenceManager.getValue(
                          key: SharedPreferenceKeys.USER_ROLE) ==
                      Role.student.name)
                    Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == "Select Option" || value == null) {
                              return "Please select an hour";
                            }
                            return null;
                          },
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTime = newValue!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Hour",
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
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == "Select Option" || value == null) {
                              return "Please select minute";
                            }
                            return null;
                          },
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMinute = newValue!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Minute",
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
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == "Select Option" || value == null) {
                              return "Please select mid day";
                            }
                            return null;
                          },
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMidDay = newValue!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Mid Day",
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
                        const SizedBox(height: 8),
                        SizedBox(
                          width: context.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () => submitRequest(selectedRoute,
                                selectedTime, selectedMinute, selectedMidDay),
                            child: Text('Request'),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Requested buses",
                        style: context.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      //Number Of Requests
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: getBusRequestStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                              final numberOfRequests =
                                  requestData['number_of_request'] ?? 0;

                              // Add the item to the list
                              if (numberOfRequests > 0) {
                                requestItems.add(Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          requestedTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Requests: $numberOfRequests',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            bool isAdmin =
                                                sharedPreferenceManager.getValue(
                                                        key:
                                                            SharedPreferenceKeys
                                                                .USER_ROLE) ==
                                                    Role.admin.name;
                                            DateFormat dateFormat =
                                                DateFormat('h:mma');
                                            DateTime dateTime =
                                                dateFormat.parse(requestedTime);
                                            String hours = DateFormat('h')
                                                .format(dateTime);
                                            String minutes = DateFormat('mm')
                                                .format(dateTime);
                                            String midDay = DateFormat('a')
                                                .format(dateTime);
                                            if (isAdmin) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content:
                                                        const SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.question_mark,
                                                            color: primaryColor,
                                                            size: 50,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              'Are you sure you want to delete this request?'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          context
                                                              .pop(); // Close the dialog without action
                                                        },
                                                        child: const Text('No'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            deleteRequest(
                                                                selectedRoute,
                                                                hours,
                                                                minutes,
                                                                midDay);
                                                            context.pop();
                                                          } catch (e) {
                                                            context.pop();
                                                          }
                                                        },
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              submitRequest(selectedRoute,
                                                  hours, minutes, midDay);
                                            }
                                          },
                                          child: sharedPreferenceManager.getValue(
                                                      key: SharedPreferenceKeys
                                                          .USER_ROLE) ==
                                                  Role.admin.name
                                              ? Text('Delete')
                                              : Text('Request'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                              } else {
                                const SizedBox.shrink();
                              }
                            }
                            // Horizontal ListView displaying the requested times and their counts
                            return requestItems.isEmpty
                                ? SizedBox(
                                    height: context.height * .20,
                                    child: const Center(
                                      child: Text("No requests available"),
                                    ))
                                : SizedBox(
                                    height: context.height * .20,
                                    child: Expanded(
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: requestItems,
                                      ),
                                    ));
                          } else {
                            const SizedBox.shrink();
                          }

                          return const Center(child: Text('No data available'));
                        },
                      ),

                      const SizedBox(height: 8),

                      StreamBuilder(
                          stream: getApprovedBusStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {}

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return SizedBox.shrink();
                            }

                            List<BusModel> buses = snapshot.data ?? [];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Approved buses",
                                  style: context.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: buses.length,
                                  // Example post count
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  height: context.height * .1,
                                                  width: context.width * .25,
                                                  imageUrl: (buses[index]
                                                                  .image ??
                                                              dummyBusImage) ==
                                                          ""
                                                      ? dummyBusImage
                                                      : buses[index].image ??
                                                          dummyUserImage,
                                                  // placeholder: (context, url) =>
                                                  //     CircularProgressIndicator(color: Colors.white,),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        buses[index].number ??
                                                            'Bus Number not available',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      // Text(
                                                      //   'Route: ${buses[index].route}',
                                                      //   style: Theme.of(context)
                                                      //       .textTheme
                                                      //       .bodyMedium,
                                                      // ),
                                                      Text(
                                                        'Time: ${buses[index].time}',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                sharedPreferenceManager.getValue(
                                                            key: SharedPreferenceKeys
                                                                .USER_ROLE) ==
                                                        Role.admin.name
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            color:
                                                                primaryColor),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                content:
                                                                    const SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .question_mark,
                                                                        color:
                                                                            primaryColor,
                                                                        size:
                                                                            50,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          'Are you sure you want to delete this bus?'),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      context
                                                                          .pop(); // Close the dialog without action
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                            'No'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        deleteApprovedBus(
                                                                            buses[index].route,
                                                                            buses[index].time,
                                                                            buses[index].number);
                                                                        context
                                                                            .pop();
                                                                      } catch (e) {
                                                                        context
                                                                            .pop();
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Yes'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Space between posts
                                      ],
                                    );
                                  },
                                )
                              ],
                            );
                          })

                      // //Card Load of Approved busses When Admin Makes it
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     //Creates Card For Approved busses
                      //     StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      //       stream: getBusRequestStream(),
                      //       builder: (context, snapshot) {
                      //         if (snapshot.connectionState ==
                      //             ConnectionState.waiting) {
                      //           return const Center(
                      //               child: CircularProgressIndicator());
                      //         }
                      //
                      //         if (snapshot.hasError) {
                      //           return Text('Error: ${snapshot.error}');
                      //         }
                      //
                      //         if (!snapshot.hasData ||
                      //             snapshot.data!.docs.isEmpty) {
                      //           return const Text('No requests found');
                      //         }
                      //
                      //         final requestDocs = snapshot.data!.docs;
                      //
                      //         List<Widget> requestCards = [];
                      //         requestCards.add(
                      //           StreamBuilder<
                      //               QuerySnapshot<Map<String, dynamic>>>(
                      //             stream: getApprovedBusStream(),
                      //             builder: (context, busSnapshot) {
                      //               if (busSnapshot.connectionState ==
                      //                   ConnectionState.waiting) {
                      //                 return const SizedBox.shrink();
                      //               }
                      //
                      //               if (busSnapshot.hasError) {
                      //                 return Text(
                      //                     'Error fetching approved buses: ${busSnapshot.error}');
                      //               }
                      //
                      //               if (!busSnapshot.hasData ||
                      //                   busSnapshot.data!.docs.isEmpty) {
                      //                 return const SizedBox.shrink();
                      //               }
                      //
                      //
                      //
                      //               List<BusModel> buses = busSnapshot.data!.docs
                      //                   .map((doc) => BusModel.fromJson(doc.data()))
                      //                   .toList();
                      //
                      //               for (var bus in buses) {
                      //                 return Card(
                      //                   elevation: 4,
                      //                   margin: const EdgeInsets.symmetric(
                      //                       vertical: 8, horizontal: 16),
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(16),
                      //                   ),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     child: Row(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         bus.image != null
                      //                             ? ClipRRect(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         8),
                      //                                 child: Image.network(
                      //                                   bus.image!,
                      //                                   width: 60,
                      //                                   height: 60,
                      //                                   fit: BoxFit.cover,
                      //                                   errorBuilder: (context,
                      //                                       error, stackTrace) {
                      //                                     return const Icon(
                      //                                         Icons
                      //                                             .directions_bus,
                      //                                         size: 60);
                      //                                   },
                      //                                 ),
                      //                               )
                      //                             : const Icon(
                      //                                 Icons.directions_bus,
                      //                                 size: 60),
                      //                         const SizedBox(width: 16),
                      //                         Expanded(
                      //                           child: Column(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             children: [
                      //                               Text(
                      //                                 bus.number ??
                      //                                     'Bus Number not available',
                      //                                 style: Theme.of(context)
                      //                                     .textTheme
                      //                                     .titleLarge
                      //                                     ?.copyWith(
                      //                                       fontWeight:
                      //                                           FontWeight.bold,
                      //                                     ),
                      //                               ),
                      //                               const SizedBox(height: 4),
                      //                               Text(
                      //                                 'Route: ${bus.route}',
                      //                                 style: Theme.of(context)
                      //                                     .textTheme
                      //                                     .bodyMedium,
                      //                               ),
                      //                               Text(
                      //                                 'Time: ${bus.time}',
                      //                                 style: Theme.of(context)
                      //                                     .textTheme
                      //                                     .bodyMedium,
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                         sharedPreferenceManager.getValue(
                      //                                     key:
                      //                                         SharedPreferenceKeys
                      //                                             .USER_ROLE) ==
                      //                                 Role.admin.name
                      //                             ? IconButton(
                      //                                 icon: const Icon(
                      //                                     Icons.delete,
                      //                                     color: Colors.red),
                      //                                 onPressed: () {
                      //                                   deleteBusRequest(
                      //                                       bus.route,
                      //                                       bus.time,
                      //                                       bus.number);
                      //                                 },
                      //                               )
                      //                             : const SizedBox.shrink(),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 );
                      //               }
                      //               return const SizedBox.shrink();
                      //             },
                      //           ),
                      //         );
                      //
                      //         return ListView(
                      //           shrinkWrap: true,
                      //           children: requestCards,
                      //         );
                      //       },
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
