import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/features/bus_track/data/data_source/bus_track_remote_data_source.dart';
import 'package:lu_assist/src/features/bus_track/presentation/view_model/bus_track_generic.dart';
import 'package:lu_assist/src/shared/data/data_source/bus_remote_data_source.dart';
import 'package:lu_assist/src/shared/data/model/bus_model.dart';

import '../../../../core/network/responses/failure_response.dart';
import '../../../../core/network/responses/success_response.dart';

final busTrackProvider =
StateNotifierProvider<BusTrackController, BusTrackGeneric>(
      (ref) => BusTrackController(ref),
);

class BusTrackController extends StateNotifier<BusTrackGeneric> {
  BusTrackController(this.ref) : super(BusTrackGeneric());
  Ref ref;
  BusRemoteDataSource busRemoteDataSource = BusRemoteDataSource();
  BusTrackRemoteDataSource busTrackRemoteDataSource =
  BusTrackRemoteDataSource();

  // Future<Stream<List<TrackModel>>> trackRouteOne() async {
  //   Stream<List<TrackModel>> response = await busTrackRemoteDataSource.trackRouteOne();
  //   return response;
  // }
  //
  // Future<Stream<List<TrackModel>>> trackRouteTwo() async {
  //   Stream<List<TrackModel>> response = await busTrackRemoteDataSource.trackRouteTwo();
  //   return response;
  // }
  //
  // Future<Stream<List<TrackModel>>> trackRouteThree() async {
  //   Stream<List<TrackModel>> response = await busTrackRemoteDataSource.trackRouteThree();
  //   return response;
  // }
  //
  // Future<Stream<List<TrackModel>>> trackRouteFour() async {
  //   Stream<List<TrackModel>> response = await busTrackRemoteDataSource.trackRouteFour();
  //   return response;
  // }

  Future<Stream<List<BusModel>>> listenRouteOneBusSchedule() async {
    state = state.update(isLoading: true);
    Stream<List<BusModel>> response = await busTrackRemoteDataSource.listenRouteOneBusSchedule();
    state = state.update(isLoading: false);
    return response;
  }

  Future<Stream<List<BusModel>>> listenRouteTwoBusSchedule() async {
    state = state.update(isLoading: true);
    Stream<List<BusModel>> response = await busTrackRemoteDataSource.listenRouteTwoBusSchedule();
    state = state.update(isLoading: false);
    return response;
  }


  Future<Stream<List<BusModel>>> listenRouteThreeBusSchedule() async {
    state = state.update(isLoading: true);
    Stream<List<BusModel>> response = await busTrackRemoteDataSource.listenRouteThreeBusSchedule();
    state = state.update(isLoading: false);
    return response;
  }


  Future<Stream<List<BusModel>>> listenRouteFourBusSchedule() async {
    state = state.update(isLoading: true);
    Stream<List<BusModel>> response = await busTrackRemoteDataSource.listenRouteFourBusSchedule();
    state = state.update(isLoading: false);
    return response;

  }

  getStream(String route) async {
    switch(route) {
      case "Route 1" :  {
        state = state.update(routeStream: listenRouteOneBusSchedule());
      }
      case "Route 2" :  {
        state = state.update(routeStream: listenRouteTwoBusSchedule());
      }
      case "Route 3" :  {
        state = state.update(routeStream: listenRouteThreeBusSchedule());
      }
      case "Route 4" :  {
        state = state.update(routeStream: listenRouteFourBusSchedule());
      }
    }
  }

  setTimeTabController(String time, TabController timeTabController) {
    state = state.update(time: time);
    state = state.update(timeTabController: timeTabController);
  }

  setTime(String time) {
    state = state.update(time: time);
  }

  Future<bool> updateBusLocation({required String arrivalPoint, required DateTime arrivalTime, required String busNumber, required route}) async {
    bool isSuccess = false;
    //state = state.update(isLoading: true);
    Either<Failure, Success> response =
    await busTrackRemoteDataSource.updateBusLocation(arrivalPoint: arrivalPoint, arrivalTime: arrivalTime, busNumber: busNumber, route: route);
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      isSuccess = true;
      BotToast.showText(text: right.message);
    });
    //state = state.update(isLoading: false);
    return isSuccess;
  }


}
