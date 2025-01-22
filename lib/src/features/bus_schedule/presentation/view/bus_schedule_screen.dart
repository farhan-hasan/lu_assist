import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view/route_schedules/route_one/route_one_schedule.dart';

class BusScheduleScreen extends ConsumerStatefulWidget {
  const BusScheduleScreen({super.key});

  static const route = '/schedule_screen';

  static setRoute() => '/schedule_screen';

  @override
  ConsumerState<BusScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<BusScheduleScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Route 1",style: context.titleSmall,)),
                ElevatedButton(onPressed: () {}, child: Text("Route 2")),
                ElevatedButton(onPressed: () {}, child: Text("Route 3")),
                ElevatedButton(onPressed: () {}, child: Text("Route 4")),
              ],
            ),
            SizedBox(height: 12,),
            SizedBox(
              height: context.height*.05,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text("Saturday")),
                  ElevatedButton(onPressed: () {}, child: Text("Sunday")),
                  ElevatedButton(onPressed: () {}, child: Text("Monday")),
                  ElevatedButton(onPressed: () {}, child: Text("Tuesday")),
                  ElevatedButton(onPressed: () {}, child: Text("Wednesday")),
                  ElevatedButton(onPressed: () {}, child: Text("Thursday")),
                  ElevatedButton(onPressed: () {}, child: Text("Friday")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


