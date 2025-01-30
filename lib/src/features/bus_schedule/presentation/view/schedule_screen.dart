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
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../bus_list/data/model/bus_model.dart';
import '../view_model/schedule_controller.dart';
import 'compononts/bus_schedule_card.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  static const route = '/schedule_screen';

  static setRoute() => '/schedule_screen';

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen>
    with TickerProviderStateMixin {
  List<String> routeNames = ["Route 1", "Route 2", "Route 3", "Route 4"];
  List<String> dayNames = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  late TabController routeTabController;
  late TabController dayTabController;
  ValueNotifier<String> selectedRoute = ValueNotifier("Route 1");
  ValueNotifier<String> selectedDay = ValueNotifier("Saturday");
  SharedPreferenceManager sharedPreferenceManager =
      sl.get<SharedPreferenceManager>();
  ValueNotifier<List<BusModel>> busScheduleListener = ValueNotifier([]);
  ValueNotifier<Map<String, List<BusModel>>> groupedBusesListener =
      ValueNotifier({});

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      busScheduleListener.value =
          await ref.read(busScheduleProvider.notifier).getAllBusSchedule();
      groupBusesByTimeRouteAndDay(
          busScheduleListener.value, selectedRoute.value, selectedDay.value);
    });
    routeTabController = TabController(length: 4, vsync: this);
    dayTabController = TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    routeTabController.dispose();
    dayTabController.dispose();
    super.dispose();
  }

  refreshSchedule(bool isSuccess) async {
    if (isSuccess) {
      busScheduleListener.value =
          await ref.read(busScheduleProvider.notifier).getAllBusSchedule();
      groupBusesByTimeRouteAndDay(
          busScheduleListener.value, selectedRoute.value, selectedDay.value);
    }
  }

  void groupBusesByTimeRouteAndDay(
      List<BusModel> buses, String routeFilter, String dayFilter) {
    groupedBusesListener.value = {};
    for (var bus in buses) {
      // Check if the bus matches the route and day filters
      if (bus.time != null &&
          bus.route == routeFilter &&
          bus.day == dayFilter) {
        groupedBusesListener.value.putIfAbsent(bus.time!, () => []).add(bus);
      }
    }
    // Sort the grouped map by time in 12-hour AM/PM format
    groupedBusesListener.value = Map.fromEntries(
      groupedBusesListener.value.entries.toList()
        ..sort((a, b) {
          // Parse the time strings for comparison
          DateTime timeA = _parse12HourTime(a.key);
          DateTime timeB = _parse12HourTime(b.key);

          return timeA.compareTo(timeB);
        }),
    );
  }

// Helper function to parse time in 12-hour format (e.g., "8:00 AM")
  DateTime _parse12HourTime(String time) {
    final DateFormat format = DateFormat("h:mm a");
    return format.parse(time);
  }

  @override
  Widget build(BuildContext context) {
    final scheduleController = ref.watch(busScheduleProvider);
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  const Text("Bus Schedule"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight * 2),
            // Adjust height for both TabBars
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  //SizedBox(height: 10,),
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
                          //filterBuses();
                          groupBusesByTimeRouteAndDay(busScheduleListener.value,
                              selectedRoute.value, selectedDay.value);
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
                  Center(
                    child: Card(
                      child: TabBar(
                        splashFactory: NoSplash.splashFactory,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        onTap: (value) {
                          selectedDay.value = dayNames[dayTabController.index];
                          debug(selectedDay.value);
                          //filterBuses();
                          groupBusesByTimeRouteAndDay(busScheduleListener.value,
                              selectedRoute.value, selectedDay.value);
                        },
                        indicator: BoxDecoration(
                          color: primaryColor,
                          // Background color for the indicator
                          borderRadius: BorderRadius.circular(10),
                          // Rounded corners
                        ),
                        labelStyle: context.bodySmall,
                        dividerHeight: 0,
                        indicatorColor: primaryColor,
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle: context.bodyExtraSmall,
                        labelColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: dayTabController,
                        tabs: dayNames.map((name) => Tab(text: name)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: sharedPreferenceManager.getValue(
                    key: SharedPreferenceKeys.USER_ROLE) ==
                Role.admin.name
            ? FloatingActionButton(
                onPressed: () {
                  context.push(CreateScheduleScreen.route,
                      extra: (bool isSuccess) => refreshSchedule(isSuccess));
                },
                child: const Icon(Icons.add),
              )
            : null,
        body: ValueListenableBuilder(
          builder: (context, value, child) {
            return scheduleController.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : groupedBusesListener.value.isEmpty
                    ? const Center(
                        child: Text("No Buses available"),
                      )
                    : ListView(
                        children:
                            groupedBusesListener.value.entries.map((entry) {
                          final time = entry.key;
                          final busesAtTime = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Time Heading
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  time,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              // Horizontal ListView for buses
                              SizedBox(
                                height: context.height*.15,
                                width: context.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: busesAtTime.length,
                                  itemBuilder: (context, index) {
                                    final bus = busesAtTime[index];
                                    return BusScheduleCard(
                                      bus: bus,
                                      onDelete: (bool isSuccess) =>
                                          refreshSchedule(isSuccess),
                                    ); // Replace with your BusCard widget
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
          },
          valueListenable: groupedBusesListener,
        ),
      ),
    );
  }
}
