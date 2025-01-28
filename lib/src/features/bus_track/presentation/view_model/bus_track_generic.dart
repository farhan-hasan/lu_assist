import 'package:flutter/material.dart';
import 'package:lu_assist/src/features/bus_list/data/model/bus_model.dart';

class BusTrackGeneric {
  bool isLoading;
  Future<Stream<List<BusModel>>>? routeStream;
  String? time;
  TabController? timeTabController;

  BusTrackGeneric({this.isLoading = false, this.routeStream, this.time, this.timeTabController});

  BusTrackGeneric update(
      {bool? isLoading, Future<Stream<List<BusModel>>>? routeStream, String? time, TabController? timeTabController}) {
    return BusTrackGeneric(
      isLoading: isLoading ?? this.isLoading,
      time: time ?? this.time,
      routeStream: routeStream ?? this.routeStream,
      timeTabController: timeTabController ?? this.timeTabController,
    );
  }
}
