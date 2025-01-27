import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/core/utils/logger/logger.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view_model/schedule_controller.dart';
import 'package:lu_assist/src/shared/data/model/bus_model.dart';

class CreateScheduleScreen extends ConsumerStatefulWidget {
  CreateScheduleScreen({super.key,required this.onCreate});

  static const route = '/create_schedule_screen';
  static setRoute() => '/create_schedule_screen';
  final Function(bool isSuccess) onCreate;

  @override
  ConsumerState<CreateScheduleScreen> createState() =>
      _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends ConsumerState<CreateScheduleScreen> {
  List<String> routeNames = [
    "Select Option",
    "Route 1",
    "Route 2",
    "Route 3",
    "Route 4"
  ];

  List<String> dayNames = [
    "Select Option",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];

  List<String> hourNames = [
    "Select Option",
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

  List<String> minuteNames = ["Select Option", "00", "15", "30", "45"];

  List<String> midDayNames = ["Select Option", "AM", "PM"];

  List<String> destinationNames = ["Select Option", "Home", "Campus"];

  ValueNotifier<List<BusModel>> busListListener = ValueNotifier([]);

  final TextEditingController busNumberController = TextEditingController();

  final TextEditingController routeController = TextEditingController();

  final TextEditingController dayController = TextEditingController();

  final TextEditingController hourController = TextEditingController();

  final TextEditingController minuteController = TextEditingController();

  final TextEditingController midDayController = TextEditingController();

  final TextEditingController destinationController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      busListListener.value =
          await ref.read(busScheduleProvider.notifier).getAllBuses();
      busListListener.value
          .insert(0, BusModel(number: "Select Option", allocated: false));
      for (BusModel b in busListListener.value) {
        debug(b.toJson());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleController = ref.watch(busScheduleProvider);
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(centerTitle: true,title: const Text("Create Schedule")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Wrap(
                runSpacing: 10,
                children: [
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == "Select Option" || value == null) {
                        return "Please select a route";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Route",
                    ),
                    dropdownColor: Colors.white,
                    // Set dropdown background color
                    items: routeNames
                        .map((route) => DropdownMenuItem<String>(
                              value: route,
                              child: Text(route),
                            ))
                        .toList(),
                    onChanged: (value) {
                      routeController.text = value ?? "";
                    },
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == "Select Option" || value == null) {
                        return "Please select a day";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Day",
                    ),
                    dropdownColor: Colors.white,
                    // Set dropdown background color
                    items: dayNames
                        .map((day) => DropdownMenuItem<String>(
                              value: day,
                              child: Text(day),
                            ))
                        .toList(),
                    onChanged: (value) {
                      dayController.text = value ?? "";
                    },
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == "Select Option" || value == null) {
                        return "Please select an hour";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Hour",
                    ),
                    dropdownColor: Colors.white,
                    // Set dropdown background color
                    items: hourNames
                        .map((hour) => DropdownMenuItem<String>(
                              value: hour,
                              child: Text(hour),
                            ))
                        .toList(),
                    onChanged: (value) {
                      hourController.text = value ?? "";
                    },
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == "Select Option" || value == null) {
                        return "Please select minute";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Minute",
                    ),
                    dropdownColor: Colors.white,
                    // Set dropdown background color
                    items: minuteNames
                        .map((minute) => DropdownMenuItem<String>(
                              value: minute,
                              child: Text(minute),
                            ))
                        .toList(),
                    onChanged: (value) {
                      minuteController.text = value ?? "";
                    },
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == "Select Option" || value == null) {
                        return "Please select Mid Day";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Mid Day",
                    ),
                    dropdownColor: Colors.white,
                    // Set dropdown background color
                    items: midDayNames
                        .map((midDay) => DropdownMenuItem<String>(
                              value: midDay,
                              child: Text(midDay),
                            ))
                        .toList(),
                    onChanged: (value) {
                      midDayController.text = value ?? "";
                    },
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == "Select Option" || value == null) {
                        return "Please select Destination";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Destination",
                    ),
                    dropdownColor: Colors.white,
                    // Set dropdown background color
                    items: destinationNames
                        .map((destination) => DropdownMenuItem<String>(
                              value: destination,
                              child: Text(destination),
                            ))
                        .toList(),
                    onChanged: (value) {
                      destinationController.text = value ?? "";
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: busListListener,
                      builder: (context, busList, child) {
                        return DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == "Select Option" || value == null) {
                              return "Please select Bus";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: busListListener.value.length == 1 ? "No buses available" : "Bus",
                          ),
                          dropdownColor: Colors.white,
                          // Set dropdown background color
                          items: busListListener.value
                              .where((bus) =>
                                  bus.allocated ==
                                  false) // Filter buses where allocated is false
                              .map((bus) => DropdownMenuItem<String>(
                                    value: bus.number,
                                    child: Text(
                                        "${bus.number ?? ""} ${(bus.number != "Select Option") ? "(${bus.type ?? ""})" : ""} "),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            busNumberController.text = value ?? "";
                          },
                        );
                      }),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        String arrivalPoint = "";
                        DateTime arrivalTime;
                        String time =
                            "${hourController.text}:${minuteController.text} ${midDayController.text}";
                        switch(routeController.text) {
                          case "Route 1" : arrivalPoint = "Tilagor";
                          case "Route 2" : arrivalPoint = "Shurma Tower";
                          case "Route 3" : arrivalPoint = "Lakkatura";
                          case "Route 4" : arrivalPoint = "Tilagor";
                        }
                        debug(time);

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

                        if (formKey.currentState!.validate()) {
                          BusModel busModel = BusModel();
                          busModel.number = busNumberController.text;
                          busModel.route = routeController.text;
                          busModel.day = dayController.text;

                          busModel.time = time;
                          busModel.incoming =
                              (destinationController.text == "Campus"
                                  ? true
                                  : false);
                          busModel.image = busListListener.value
                              .firstWhere((bus) =>
                                  bus.number == busNumberController.text)
                              .image;
                          busModel.allocated = true;
                          busModel.arrivalPoint = arrivalPoint;
                          busModel.arrivalTime = result;
                          busModel.type = busListListener.value
                              .firstWhere((bus) =>
                                  bus.number == busNumberController.text)
                              .type;

                          bool isSuccess = await ref
                              .read(busScheduleProvider.notifier)
                              .createSchedule(busModel: busModel);

                          if (isSuccess) {
                            await ref
                                .read(busScheduleProvider.notifier)
                                .toggleBusAllocation(busModel: busModel);
                            widget.onCreate(isSuccess);
                          }
                          if (mounted) {
                            context.pop();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: scheduleController.isLoading
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            )
                          : const Text(
                              'Create',
                              style: TextStyle(fontSize: 16.0),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
