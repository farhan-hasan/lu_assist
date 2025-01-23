import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/network/responses/success_response.dart';
import 'package:lu_assist/src/features/bus_schedule/data/data_source/bus_schedule_remote_data_source.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view_model/schedule_generic.dart';
import 'package:lu_assist/src/shared/data/data_source/bus_remote_data_source.dart';
import 'package:lu_assist/src/shared/data/model/bus_model.dart';

import '../../../../core/network/responses/failure_response.dart';

final busScheduleProvider =
    StateNotifierProvider<ScheduleController, ScheduleGeneric>(
  (ref) => ScheduleController(ref),
);

class ScheduleController extends StateNotifier<ScheduleGeneric> {
  ScheduleController(this.ref) : super(ScheduleGeneric());
  Ref ref;
  BusRemoteDataSource busRemoteDataSource = BusRemoteDataSource();
  BusScheduleRemoteDataSource busScheduleRemoteDataSource =
      BusScheduleRemoteDataSource();

  Future<List<BusModel>> getAllBuses() async {
    List<BusModel> busList = [];
    state = state.update(isLoading: true);
    Either<Failure, List<BusModel>> response =
        await busRemoteDataSource.getAllBuses();
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      BotToast.showText(text: "Buses fetched Successfully");
      busList = right;
      state = state.update(busList: right);
    });
    state = state.update(isLoading: false);
    return busList;
  }

  Future<List<BusModel>> getAllBusSchedule() async {
    List<BusModel> busList = [];
    state = state.update(isLoading: true);
    Either<Failure, List<BusModel>> response =
        await busScheduleRemoteDataSource.getAllBusSchedule();
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      BotToast.showText(text: "All Bus Schedules fetched Successfully");
      busList = right;
      state = state.update(busList: right);
    });
    state = state.update(isLoading: false);
    return busList;
  }

  Future<bool> createSchedule({required BusModel busModel}) async {
    bool isSuccess = false;
    state = state.update(isLoading: true);
    Either<Failure, Success> response =
        await busScheduleRemoteDataSource.createSchedule(busModel: busModel);
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      isSuccess = true;
      BotToast.showText(text: right.message);
    });
    state = state.update(isLoading: false);
    return isSuccess;
  }

  Future<bool> deleteSchedule({required BusModel busModel}) async {
    bool isSuccess = false;
    state = state.update(isLoading: true);
    Either<Failure, Success> response =
    await busScheduleRemoteDataSource.deleteSchedule(busModel: busModel);
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      isSuccess = true;
      BotToast.showText(text: right.message);
    });
    state = state.update(isLoading: false);
    return isSuccess;
  }

  Future<bool> updateSchedule({required BusModel busModel, required BusModel oldBusModel}) async {
    bool isSuccess = false;
    state = state.update(isLoading: true);
    Either<Failure, Success> response =
    await busScheduleRemoteDataSource.updateSchedule(busModel: busModel, oldBusModel: oldBusModel);
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      isSuccess = true;
      BotToast.showText(text: right.message);
    });
    state = state.update(isLoading: false);
    return isSuccess;
  }

  Future<bool> toggleBusAllocation({required BusModel busModel}) async {
    bool isSuccess = false;
    state = state.update(isLoading: true);
    Either<Failure, Success> response =
        await busRemoteDataSource.toggleBusAllocation(busModel: busModel);
    response.fold((left) {
      isSuccess = true;
      BotToast.showText(text: left.message);
    }, (right) {
      BotToast.showText(text: right.message);
    });
    state = state.update(isLoading: false);
    return isSuccess;
  }
}
