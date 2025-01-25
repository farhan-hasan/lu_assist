import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/features/bus_track/presentation/view_model/bus_track_controller.dart';

import '../../../../core/styles/theme/app_theme.dart';
import '../../../../core/utils/logger/logger.dart';
import '../../../../shared/data/model/bus_model.dart';

class TrackScreen extends ConsumerStatefulWidget {
  const TrackScreen({super.key});

  static const route = '/track_screen';

  static setRoute() => '/track_screen';

  @override
  ConsumerState<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends ConsumerState<TrackScreen>
    with TickerProviderStateMixin {
  late TabController routeTabController, timeTabController;
  List<String> routeNames = ["Route 1", "Route 2", "Route 3", "Route 4"];
  ValueNotifier<List<String>> routePoints = ValueNotifier([]);
  ValueNotifier<List<String>> timeTabs = ValueNotifier([]);
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
  ValueNotifier<String> selectedTime = ValueNotifier("");

  ValueNotifier<Stream<List<BusModel>>> trackStream = ValueNotifier(Stream.value([]));



  @override
  void initState() {
    routeTabController = TabController(length: 4, vsync: this);
    routePoints.value = routeOnePoints;
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      trackStream.value = await ref.read(busTrackProvider.notifier).listenRouteOneBusSchedule();
    });

    super.initState();
  }

  // initTimeTabs() {
  //   // Extract unique, non-null `time` values
  //   final uniqueTimes = trackStream.value.
  //       .where((bus) => bus.time != null && bus.time!.isNotEmpty)
  //       .map((bus) => bus.time!)
  //       .toSet()
  //       .toList();
  //
  //   // Sort the times
  //   uniqueTimes.sort((a, b) {
  //     // Convert to DateTime for sorting
  //     final timeA = _parseTime(a);
  //     final timeB = _parseTime(b);
  //     return timeA.compareTo(timeB);
  //   });
  // }

  DateTime _parseTime(String time) {
    final match = RegExp(r'(\d+):(\d+)\s*(AM|PM)').firstMatch(time);
    if (match != null) {
      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final isPM = match.group(3) == "PM";

      return DateTime(0, 0, 0, isPM ? (hour % 12) + 12 : hour, minute);
    }
    return DateTime(0); // Default for invalid time format
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bus Schedule'),
          bottom: PreferredSize(
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
                        onTap: (value) {
                          selectedRoute.value =
                          routeNames[routeTabController.index];
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
                        tabs:
                        routeNames.map((name) => Tab(text: name)).toList(),
                      ),
                    ),
                  ),
                  //SizedBox(height: 10,),

                  FutureBuilder(
                    future: ref.read(busTrackProvider.notifier).listenRouteOneBusSchedule(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return StreamBuilder<List<BusModel>>(
                          stream: snapshot.data,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const LinearProgressIndicator();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No data available'));
                            }

                            // Extract the list of buses
                            final busList = snapshot.data!;

                            // Extract unique and sorted time values
                            final uniqueTimes = busList
                                .where((bus) => bus.time != null && bus.time!.isNotEmpty)
                                .map((bus) => bus.time!)
                                .toSet()
                                .toList();

                            // Sort the times
                            uniqueTimes.sort((a, b) {
                              final timeA = _parseTime(a);
                              final timeB = _parseTime(b);
                              return timeA.compareTo(timeB);
                            });

                            // Set the sorted times for the TabBar
                            timeTabs.value = uniqueTimes;

                            selectedTime.value = uniqueTimes.first;

                            timeTabController = TabController(length: timeTabs.value.length, vsync: this);

                            return TabBar(
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              splashFactory: NoSplash.splashFactory,
                              onTap: (value) {
                                selectedRoute.value =
                                routeNames[routeTabController.index];
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
                              controller: timeTabController,
                              tabs: timeTabs.value
                                  .map((time) => Tab(text: time))
                                  .toList(), // Create a tab for each time
                            );
                          },
                        );
                      }
                      else {
                        return SizedBox.shrink();
                      }
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: routePoints,
            builder: (context, points, child) {
              return ListView(
                children: points.asMap().entries.map((point) {
                  // Replace with your custom widget for each point
                  return Column(
                    children: [
                      Card(
                        child: ListTile(
                          trailing: Icon(Icons.circle_outlined),
                          title: Text(
                            point.value,
                            style: context.titleLarge,
                          ),
                          subtitle: Text(
                            "Last passed: ",
                            style: context.bodySmall,
                          ),
                        ),
                      ),
                      if (point.key != points.length - 1)
                        Center(
                        child: Lottie.asset("assets/gifs/down_arrow.json",
                            frameRate: FrameRate.max, width: 100, height: 50),
                      ),
                    ],
                  );
                }).toList(),
              );
            }
          ),
        ));
  }
}

// Center(
// child: Lottie.asset("assets/gifs/down_arrow.json",
// frameRate: FrameRate.max,
// width: 100,
// height: 50
// ),
// ),
