import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/features/bus_track/presentation/view_model/bus_track_controller.dart';

import '../../../../core/styles/theme/app_theme.dart';
import '../../../../core/utils/logger/logger.dart';
import '../../../bus_list/data/model/bus_model.dart';

class TrackScreen extends ConsumerStatefulWidget {
  const TrackScreen({super.key});

  static const route = '/track_screen';

  static setRoute() => '/track_screen';

  @override
  ConsumerState<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends ConsumerState<TrackScreen>
    with TickerProviderStateMixin {
  late TabController routeTabController;
  late TabController timeTabController;
  List<String> routeNames = ["Route 1", "Route 2", "Route 3", "Route 4"];
  ValueNotifier<List<String>> routePoints = ValueNotifier([]);
  ValueNotifier<List<String>> timeTabs = ValueNotifier(["Select Time"]);
  List<String> routeFourPoints = [
    "Tilagor",
    "Shibgonj",
    "Mirabazar",
    "Naiorpul",
    "Subhanighat",
    "Uposhahar",
    "Humayun Chattar",
    "Chondipul",
    "Rail Crossing",
    "Kamal Bazar",
    "Campus"
  ];
  List<String> routeOnePoints = [
    "Tilagor",
    "Baluchor",
    "Arambag",
    "TB Gate",
    "Shahi Eidgah",
    "Amberkhana",
    "Shubid Bazar",
    "Pathantula",
    "Modina Market",
    "Akhalia",
    "SUST Gate",
    "Temukhi",
    "Rail Crossing",
    "Kamal Bazar",
    "Campus"
  ];
  List<String> routeTwoPoints = [
    "Shurma Tower",
    "Kazir Bazar Bridge",
    "Lama Bazar",
    "Rikabi Bazar",
    "Shubid Bazar",
    "Pathantula",
    "Modina Market",
    "Akhalia",
    "SUST Gate",
    "Temukhi",
    "Rail Crossing",
    "Kamal Bazar",
    "Campus"
  ];
  List<String> routeThreePoints = [
    "Lakkatura",
    "Chowkidekhi",
    "Khashdobir",
    "Amberkhana",
    "Shubid Bazar",
    "Pathantula",
    "Modina Market",
    "Akhalia",
    "SUST Gate",
    "Temukhi",
    "Rail Crossing",
    "Kamal Bazar",
    "Campus"
  ];
  ValueNotifier<String> selectedRoute = ValueNotifier("Route 1");
  ValueNotifier<String> selectedTime = ValueNotifier("Select Time");
  TextEditingController busNumberController = TextEditingController();

  ValueNotifier<Stream<List<BusModel>>> trackStream =
      ValueNotifier(Stream.value([]));
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    routeTabController = TabController(length: 4, vsync: this);
    timeTabController = TabController(length: 1, vsync: this);
    timeTabController.addListener(() {
      if (!timeTabController.indexIsChanging) {
        // Trigger only after the user changes tabs
        final selectedTab = timeTabs.value[timeTabController.index];
        ref.read(busTrackProvider.notifier).setTime(selectedTab);
      }
    });
    routePoints.value = routeOnePoints;
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      trackStream.value =
          await ref.read(busTrackProvider.notifier).listenRouteOneBusSchedule();
      ref.read(busTrackProvider.notifier).getStream(selectedRoute.value);
    });

    super.initState();
  }

  DateTime _parseTime(String time) {
    final match = RegExp(r'(\d+):(\d+)\s*(AM|PM)').firstMatch(time);
    if (match != null) {
      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final isPM = match.group(3) == "PM";
      DateTime now = DateTime.now();
      return DateTime(now.year, now.month, now.day, isPM ? (hour % 12) + 12 : hour, minute);
    }
    return DateTime(0); // Default for invalid time format
  }

  DateTime parseTime(String timeString) {
    final now = DateTime.now();
    final format = DateFormat('h:mm a'); // Define the format of the time string
    final parsedTime = format.parse(timeString); // Parse the time string
    // Return a DateTime with today's date and the parsed time
    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  }

  Future<Stream<List<BusModel>>> getStream(String route) async {
    switch (route) {
      case "Route 1":
        return await ref
            .read(busTrackProvider.notifier)
            .listenRouteOneBusSchedule();
      case "Route 2":
        return await ref
            .read(busTrackProvider.notifier)
            .listenRouteTwoBusSchedule();
      case "Route 3":
        return await ref
            .read(busTrackProvider.notifier)
            .listenRouteThreeBusSchedule();
      case "Route 4":
        return await ref
            .read(busTrackProvider.notifier)
            .listenRouteFourBusSchedule();
    }
    return await Stream.value([]);
  }

  // setTimeTab(String time) {
  //   ref.read(busTrackProvider.notifier).setTimeTabController(time);
  // }

  @override
  Widget build(BuildContext context) {
    final busTrackController = ref.watch(busTrackProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Bus Hunt'),
          bottom: busTrackController.isLoading
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: LinearProgressIndicator(
                    color: primaryColor,
                  ))
              : PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight * 2),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Center(
                          child: Card(
                            child: TabBar(
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              splashFactory: NoSplash.splashFactory,
                              onTap: (value) async {
                                if (selectedRoute.value ==
                                    routeNames[routeTabController.index]) {
                                  return;
                                }
                                selectedRoute.value =
                                    routeNames[routeTabController.index];
                                ref
                                    .read(busTrackProvider.notifier)
                                    .getStream(selectedRoute.value);

                                timeTabController.index = 0;
                                selectedTime.value == "Select Time";
                                debug(selectedRoute.value);
                              },
                              indicator: BoxDecoration(
                                color: primaryColor,
                                // Background color for the indicator
                                borderRadius: BorderRadius.circular(10),
                                // Rounded corners
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: context.bodySmall,
                              dividerHeight: 0,
                              indicatorColor: primaryColor,
                              unselectedLabelColor: Colors.grey,
                              unselectedLabelStyle: context.bodyExtraSmall,
                              labelColor: Colors.white,
                              controller: routeTabController,
                              tabs: routeNames
                                  .map((name) => Tab(text: name))
                                  .toList(),
                            ),
                          ),
                        ),
                        //SizedBox(height: 10,),
                        FutureBuilder(
                            future: busTrackController.routeStream,
                            builder: (context, futureSnapshot) {
                              return StreamBuilder<List<BusModel>>(
                                stream: futureSnapshot.data,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                      height: kToolbarHeight,
                                      child: LinearProgressIndicator(
                                        color: primaryColor,
                                        backgroundColor: Colors.white,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }

                                  updateTimeTabs(snapshot);

                                  return Center(
                                    child: Card(
                                      child: TabBar(
                                        isScrollable: true,
                                        tabAlignment: TabAlignment.start,
                                        splashFactory: NoSplash.splashFactory,
                                        onTap: (value) {
                                          selectedTime.value =
                                              timeTabs.value[value];
                                          //ref.read(busTrackProvider.notifier).setTime(selectedTime.value);
                                        },
                                        indicator: BoxDecoration(
                                          color: primaryColor,
                                          // Background color for the indicator
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // Rounded corners
                                        ),
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        labelStyle: context.bodySmall,
                                        dividerHeight: 0,
                                        indicatorColor: primaryColor,
                                        unselectedLabelColor: Colors.grey,
                                        unselectedLabelStyle:
                                            context.bodyExtraSmall,
                                        labelColor: Colors.white,
                                        controller: timeTabController,
                                        tabs: timeTabs.value.map((time) {
                                          return Tab(text: time);
                                        }).toList(), // Create a tab for each time
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ],
                    ),
                  ),
                ),
        ),
        body: busTrackController.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<Stream<List<BusModel>>>(
                    future: busTrackController.routeStream,
                    builder: (context, futureSnapshot) {
                      return StreamBuilder<List<BusModel>>(
                        stream: futureSnapshot.data,
                        builder: (context, snapshot) {
                          List<BusModel> busList = (snapshot.data ?? [])
                              .where(
                                  (bus) => bus.time == busTrackController.time && bus.incoming == true)
                              .toList();
                          List<BusModel> updatedBusList = busList.map((bus) {
                            if (bus.arrivalTime != null) {
                              final now = DateTime.now();
                              final difference = now.difference(bus.arrivalTime!).inMinutes;
                              // If arrival time is more than an hour from now, update the arrival point
                              if (difference > 60) {
                                bus = bus..arrivalPoint=routePoints.value.first;
                                bus = bus..arrivalTime=parseTime(bus.time ?? "");
                              }
                              return bus;
                            }
                            return bus;
                          }).toList();
                          busList = updatedBusList;
                          selectedTime.value = timeTabs.value[timeTabController.index];
                          return selectedTime.value == "Select Time"
                              ? const Center(
                            child: Text("Please select a time"),
                          )
                              :
                             ListView(
                                  children: routePoints.value
                                      .asMap()
                                      .entries
                                      .map((point) {
                                    // Check if this route point is reached
                                    final busesAtPoint = busList
                                        .where((bus) =>
                                            bus.arrivalPoint == point.value)
                                        .toList();
                                    busesAtPoint.sort((a, b) => b.arrivalTime!
                                        .compareTo(a.arrivalTime!));
                                    // Determine the card color
                                    final cardColor = busesAtPoint.isNotEmpty
                                        ? primaryColor // Highlight for reached points
                                        : Colors
                                            .white; // Default color for other points
                                    final textColor = busesAtPoint.isNotEmpty
                                        ? Colors
                                            .white // Highlight for reached points
                                        : Colors
                                            .black; // Default color for other points
                                    // Count the number of buses at this route point
                                    final busCount = busesAtPoint.length;
                                    final dateFormat = DateFormat('h:mm a');
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            pickBus(context, busList, point);
                                          },
                                          child: Card(
                                            color: cardColor,
                                            child: ListTile(
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .directions_bus_rounded,
                                                    color: textColor,
                                                    size: 20,
                                                  ),
                                                  Text(": $busCount",
                                                      style: context.bodySmall
                                                          ?.copyWith(
                                                              color: textColor))
                                                ],
                                              ),
                                              title: Text(
                                                point.value ?? "",
                                                style: context.titleLarge
                                                    ?.copyWith(
                                                        color: textColor),
                                              ),
                                              subtitle: Text(
                                                busesAtPoint.isNotEmpty
                                                    ? "Last passed: ${busesAtPoint.first.arrivalTime != null ? dateFormat.format(busesAtPoint.first.arrivalTime!) : ""}"
                                                    : "No buses here",
                                                style: context.bodySmall
                                                    ?.copyWith(
                                                        color: textColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (busesAtPoint.isNotEmpty &&
                                            point.key !=
                                                routePoints.value.length - 1)
                                          Center(
                                            child: Lottie.asset(
                                              "assets/gifs/down_arrow.json",
                                              frameRate: FrameRate.max,
                                              width: 100,
                                              height: 50,
                                            ),
                                          ),
                                      ],
                                    );
                                  }).toList(),
                                );
                        },
                      );
                    }),
              ));
  }

  void updateTimeTabs(AsyncSnapshot<List<BusModel>> snapshot) {
    final busList = snapshot.data ?? [];
    final now = DateTime.now();
    final filteredBuses = busList.where((bus) {
      if (bus.time == null || bus.time!.isEmpty) return false; // Skip invalid times
      final busTime = parseTime(bus.time!);
      final difference = busTime.difference(now).inMinutes.abs();
      return difference <= 60; // Check if the difference is within an hour
    }).toList();
    final uniqueTimes = filteredBuses
        .where((bus) =>
            bus.time != null &&
            bus.time!.isNotEmpty)
        .map((bus) => bus.time!)
        .toSet()
        .toList();
    // Sort the times
    uniqueTimes.sort((a, b) {
      final timeA = _parseTime(a);
      final timeB = _parseTime(b);
      return timeA.compareTo(timeB);
    });
    uniqueTimes.insert(0, "Select Time");
    timeTabs.value = uniqueTimes;
    selectedTime.value = uniqueTimes.first;
    if (timeTabController.length !=
        timeTabs.value.length) {
      timeTabController.dispose();
      timeTabController = TabController(
        length: timeTabs.value.length,
        vsync: this,
      );
      timeTabController.addListener(() {
        if (!timeTabController.indexIsChanging) {
          final selectedTab = timeTabs
              .value[timeTabController.index];
          debug(selectedTab);
          ref
              .read(busTrackProvider.notifier)
              .setTime(selectedTab);
        }
      });
    }
  }

  void pickBus(BuildContext context, List<BusModel> busList,
      MapEntry<int, String> point) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.bus_alert,
                    color: primaryColor,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Pick the bus you hunted",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    iconSize: 0,
                    validator: (value) {
                      if (value == "Select Option" || value == null) {
                        return "Please select Bus";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText:
                          busList.isEmpty ? "No buses available" : "Pick Bus",
                    ),
                    dropdownColor: Colors.white,
                    // Set dropdown background color
                    items: busList // Filter buses where allocated is false
                        .map((bus) => DropdownMenuItem<String>(
                              value: bus.number,
                              child: SizedBox(
                                width: context.width*.5,
                                child: Text(
                                    "${bus.number ?? ""} ${(bus.number != "Select Option") ? "(${bus.type ?? ""})" : ""} ",style: context.bodySmall,overflow: TextOverflow.ellipsis,),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      busNumberController.text = value ?? "";
                    },
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Done',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: primaryColor),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String arrivalPoint = point.value;
                  DateTime arrivalTime = DateTime.now();
                  String busNumber = busNumberController.text;
                  context.pop();
                  selectedTime.value = timeTabs.value[timeTabController.index];
                  await ref.read(busTrackProvider.notifier).updateBusLocation(
                      route: selectedRoute.value,
                      busNumber: busNumber,
                      arrivalTime: arrivalTime,
                      arrivalPoint: arrivalPoint);
                }
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: primaryColor),
              ),
              onPressed: () async {
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Center(
// child: Lottie.asset("assets/gifs/down_arrow.json",
// frameRate: FrameRate.max,
// width: 100,
// height: 50
// ),
// ),
