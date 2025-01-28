import 'package:lu_assist/src/features/bus_list/data/model/bus_model.dart';

class ScheduleGeneric {
  bool isLoading;

  List<BusModel>? allBusSchedule;

  ScheduleGeneric({this.isLoading = false, this.allBusSchedule});

  ScheduleGeneric update(
      {bool? isLoading,
      List<BusModel>? allBusSchedule}) {
    return ScheduleGeneric(
      isLoading: isLoading ?? this.isLoading,
      allBusSchedule: allBusSchedule ?? this.allBusSchedule,
    );
  }
}
