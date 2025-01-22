import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

import '../../../../../../core/styles/theme/app_theme.dart';

class RouteOneSchedule extends ConsumerStatefulWidget {
  const RouteOneSchedule({
    super.key,
  });

  @override
  ConsumerState<RouteOneSchedule> createState() => _RouteOneScheduleState();
}

class _RouteOneScheduleState extends ConsumerState<RouteOneSchedule> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
             tabAlignment: TabAlignment.start,
            isScrollable: true,
              labelStyle: context.titleSmall,
              dividerHeight: 0,
              indicatorColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: context.bodySmall,
              labelColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Text("Saturday"),
                ),
                Tab(
                  child: Text("Sunday"),
                ),
                Tab(
                  child: Text("Monday"),
                ),
                Tab(
                  child: Text("Tuesday"),
                ),
                Tab(
                  child: Text("Wednesday"),
                ),
                Tab(
                  child: Text("Thursday"),
                ),
                Tab(
                  child: Text("Friday"),
                ),
          ]),
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText:"Hour",
                                labelStyle: context.bodySmall,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                  // Border color when not selected
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                  // Border color when selected
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              dropdownColor: Colors.white, // Set dropdown background color
                              menuMaxHeight: context.height*.3,
                              style: context.titleSmall,
                              iconSize: context.width*.06,
                              items: const [
                                DropdownMenuItem(
                                  child: Text('1', style: TextStyle(color: Colors.black)),
                                  value: '1',
                                ),
                                DropdownMenuItem(
                                  child: Text('2', style: TextStyle(color: Colors.black)),
                                  value: '2',
                                ),
                                DropdownMenuItem(
                                  child: Text('3', style: TextStyle(color: Colors.black)),
                                  value: '3',
                                ),
                                DropdownMenuItem(
                                  child: Text('4',
                                      style: TextStyle(color: Colors.black)),
                                  value: '4',
                                ),
                                DropdownMenuItem(
                                  child: Text('5',
                                      style: TextStyle(color: Colors.black)),
                                  value: '5',
                                ),
                                DropdownMenuItem(
                                  child: Text('6',
                                      style: TextStyle(color: Colors.black)),
                                  value: '6',
                                ),
                                DropdownMenuItem(
                                  child: Text('7',
                                      style: TextStyle(color: Colors.black)),
                                  value: '7',
                                ),
                                DropdownMenuItem(
                                  child:
                                  Text('8', style: TextStyle(color: Colors.black)),
                                  value: '8',
                                ),
                                DropdownMenuItem(
                                  child: Text('9', style: TextStyle(color: Colors.black)),
                                  value: '9',
                                ),
                                DropdownMenuItem(
                                  child: Text('10', style: TextStyle(color: Colors.black)),
                                  value: '10',
                                ),
                                DropdownMenuItem(
                                  child: Text('11', style: TextStyle(color: Colors.black)),
                                  value: '11',
                                ),
                                DropdownMenuItem(
                                  child: Text('12', style: TextStyle(color: Colors.black)),
                                  value: '12',
                                ),
                              ],
                              onChanged: (value) {
                                //departmentController.text = value ?? "";
                              },
                            ),
                          ),
                          SizedBox(width:10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText:"Minute",
                                labelStyle: context.bodySmall,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                  // Border color when not selected
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                  // Border color when selected
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              dropdownColor: Colors.white, // Set dropdown background color
                              menuMaxHeight: context.height*.3,
                              style: context.titleSmall,
                              iconSize: context.width*.06,
                              items: const [
                                DropdownMenuItem(
                                  child: Text('00', style: TextStyle(color: Colors.black)),
                                  value: '00',
                                ),
                                DropdownMenuItem(
                                  child: Text('15', style: TextStyle(color: Colors.black)),
                                  value: '15',
                                ),
                                DropdownMenuItem(
                                  child: Text('30', style: TextStyle(color: Colors.black)),
                                  value: '30',
                                ),
                                DropdownMenuItem(
                                  child: Text('45',
                                      style: TextStyle(color: Colors.black)),
                                  value: '45',
                                ),
                              ],
                              onChanged: (value) {
                                //departmentController.text = value ?? "";
                              },
                            ),
                          ),
                          SizedBox(width:10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText:"AM/PM",
                                labelStyle: context.bodySmall,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                  // Border color when not selected
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                  // Border color when selected
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              dropdownColor: Colors.white, // Set dropdown background color
                              menuMaxHeight: context.height*.3,
                              style: context.titleSmall,
                              iconSize: context.width*.06,
                              items: const [
                                DropdownMenuItem(
                                  child: Text('AM', style: TextStyle(color: Colors.black)),
                                  value: 'AM',
                                ),
                                DropdownMenuItem(
                                  child: Text('PM', style: TextStyle(color: Colors.black)),
                                  value: 'PM',
                                ),
                              ],
                              onChanged: (value) {
                                //departmentController.text = value ?? "";
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12,),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText:"Day",
                          labelStyle: context.bodySmall,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            // Border color when not selected
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            // Border color when selected
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        dropdownColor: Colors.white, // Set dropdown background color
                        menuMaxHeight: context.height*.3,
                        style: context.titleSmall,
                        iconSize: context.width*.06,
                        items: const [
                          DropdownMenuItem(
                            child: Text('Saturday', style: TextStyle(color: Colors.black)),
                            value: 'Saturday',
                          ),
                          DropdownMenuItem(
                            child: Text('Sunday', style: TextStyle(color: Colors.black)),
                            value: 'Sunday',
                          ),
                          DropdownMenuItem(
                            child: Text('Monday', style: TextStyle(color: Colors.black)),
                            value: 'Monday',
                          ),
                          DropdownMenuItem(
                            child: Text('Tuesday',
                                style: TextStyle(color: Colors.black)),
                            value: 'Tuesday',
                          ),
                          DropdownMenuItem(
                            child: Text('Wednesday',
                                style: TextStyle(color: Colors.black)),
                            value: 'Wednesday',
                          ),
                          DropdownMenuItem(
                            child: Text('Thursday',
                                style: TextStyle(color: Colors.black)),
                            value: 'Thursday',
                          ),
                          DropdownMenuItem(
                            child: Text('Friday',
                                style: TextStyle(color: Colors.black)),
                            value: 'Friday',
                          ),
                        ],
                        onChanged: (value) {
                          //departmentController.text = value ?? "";
                        },
                      ),
                      SizedBox(height: 12,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Search"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text("Friday"),
                Text("Friday"),
                Text("Friday"),
                Text("Friday"),
                Text("Friday"),
                Text("Friday"),
              ],
            ),
          ),

        ],
      ),
    );
  }
}