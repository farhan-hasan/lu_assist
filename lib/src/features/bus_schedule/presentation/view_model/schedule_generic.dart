import 'package:lu_assist/src/shared/data/model/bus_model.dart';

class ScheduleGeneric {
  bool isLoading;
  List<BusModel>? busList;
  List<BusModel>? allBusSchedule;

  ScheduleGeneric({this.isLoading = false, this.busList, this.allBusSchedule});

  ScheduleGeneric update(
      {bool? isLoading,
      List<BusModel>? busList,
      List<BusModel>? allBusSchedule}) {
    return ScheduleGeneric(
      isLoading: isLoading ?? this.isLoading,
      busList: busList ?? this.busList,
      allBusSchedule: allBusSchedule ?? this.allBusSchedule,
    );
  }
}
