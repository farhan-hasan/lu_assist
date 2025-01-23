import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../view_model/schedule_controller.dart';

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
  ValueNotifier<List<BusModel>> filteredBusScheduleListener = ValueNotifier([]);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      busScheduleListener.value =
          await ref.read(busScheduleProvider.notifier).getAllBusSchedule();
      filterBuses();
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

  filterBuses() {
    List<BusModel> allBuses = busScheduleListener.value;
    List<BusModel> filteredBuses = allBuses.where((bus) {
      return (bus.day == selectedDay.value && bus.route == selectedRoute.value);
    }).toList();
    filteredBusScheduleListener.value = filteredBuses;
  }

  void refreshSchedule(bool isSuccess) async {
    if(isSuccess) {
      busScheduleListener.value =
      await ref.read(busScheduleProvider.notifier).getAllBusSchedule();
      filterBuses();
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/LU_Assist__LOGO.png',
            height: context.height * 0.20,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight * 2),
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
                          filterBuses();
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
                          filterBuses();
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
                  context.push(CreateScheduleScreen.route, extra: (bool isSuccess) => refreshSchedule(isSuccess));
                },
                child: Icon(Icons.add),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: filteredBusScheduleListener,
                  builder: (context, value, child) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: value.map((bus) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bus.time ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge, // Dynamic time
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: value.where((b) => b.time == bus.time).length,
                                    // Number of BusCards per time slot
                                    itemBuilder: (context, index) {
                                      return BusCard(bus: bus, onDelete: (bool isSuccess) => refreshSchedule(isSuccess),); // Pass data
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList());
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
