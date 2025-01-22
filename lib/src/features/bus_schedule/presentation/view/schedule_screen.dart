import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/core/utils/logger/logger.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view/route_schedules/route_one/route_one_schedule.dart';

import '../../../../shared/widgets/bus_card.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  static const route = '/schedule_screen';

  static setRoute() => '/schedule_screen';

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> with TickerProviderStateMixin {
  List<String> routeNames = ["Route 1", "Route 2", "Route 3", "Route 4"];
  List<String> dayNames = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  List<String> timeSlots = List.generate(
    10,
        (index) => "${8 + index <= 12 ? 8 + index : (8 + index) - 12} ${8 + index < 12 ? "AM" : "PM"}",
  );// Generates time slots from 8 AM to 5 PM
  late TabController routeTabController;
  late TabController dayTabController;
  ValueNotifier<String> selectedRoute = ValueNotifier("Route 1");
  ValueNotifier<String> selectedDay = ValueNotifier("Saturday");

  @override
  void initState() {
    routeTabController = TabController(length: 4, vsync: this);
    dayTabController = TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    routeTabController.dispose();
    super.dispose();
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
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                splashFactory: NoSplash.splashFactory,
                onTap: (value) {
                  selectedRoute.value = routeNames[routeTabController.index];
                  debug(selectedRoute.value);
                },
                indicator: BoxDecoration(
                  color: primaryColor, // Background color for the indicator
                  borderRadius: BorderRadius.circular(100),
                  // Rounded corners
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: context.titleSmall,
                dividerHeight: 0,
                indicatorColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: context.bodySmall,
                labelColor: Colors.white,
                controller: routeTabController,
                tabs: routeNames.map((name) => Tab(text: name)).toList(),
              ),
              SizedBox(height: 10,),
              TabBar(
                splashFactory: NoSplash.splashFactory,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                onTap: (value) {
                  selectedDay.value = dayNames[dayTabController.index];
                  debug(selectedDay.value);
                },
                indicator: BoxDecoration(
                  color: primaryColor, // Background color for the indicator
                  borderRadius: BorderRadius.circular(100),
                  // Rounded corners
                ),
                labelStyle: context.titleSmall,
                dividerHeight: 0,
                indicatorColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: context.bodySmall,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                controller: dayTabController,
                tabs: dayNames.map((name) => Tab(text: name)).toList(),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: timeSlots.map((time) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            time,
                            style: Theme.of(context).textTheme.titleLarge, // Dynamic time
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.13,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4, // Number of BusCards per time slot
                              itemBuilder: (context, index) {
                                return BusCard(); // Pass data
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



