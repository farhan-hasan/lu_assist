import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/network/responses/failure_response.dart';
import 'package:lu_assist/src/core/network/responses/success_response.dart';
import 'package:lu_assist/src/features/bus_list/data/data_source/bus_remote_data_source.dart';
import 'package:lu_assist/src/features/bus_list/data/model/bus_model.dart';

import 'bus_generic.dart';


final busProvider =
StateNotifierProvider<BusController, BusGeneric>(
      (ref) => BusController(ref),
);

class BusController extends StateNotifier<BusGeneric> {
  BusController(this.ref) : super(BusGeneric());
  Ref ref;
  BusRemoteDataSource busRemoteDataSource = BusRemoteDataSource();

  Future<bool> addBus({required BusModel busModel}) async {
    bool isSuccess = false;
    state = state.update(isLoading: true);
    Either<Failure, Success> response =
    await busRemoteDataSource.addBus(busModel: busModel);
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      isSuccess = true;
      BotToast.showText(text: right.message);
    });
    state = state.update(isLoading: false);
    return isSuccess;
  }

  Future<bool> deleteBus({required BusModel busModel}) async {
    bool isSuccess = false;
    //state = state.update(isLoading: true); ... TURNED OF BECAUSE REF WAS NOT WORKING WHEN WIDGET WAS DISPOSED
    Either<Failure, Success> response =
    await busRemoteDataSource.deleteBus(busModel: busModel);
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      isSuccess = true;
      BotToast.showText(text: right.message);
    });
    //state = state.update(isLoading: false);
    return isSuccess;
  }

  Future<bool> updateBus({required BusModel busModel, required BusModel oldBusModel}) async {
    bool isSuccess = false;
    //state = state.update(isLoading: true);
    Either<Failure, Success> response =
    await busRemoteDataSource.updateBus(busModel: busModel, oldBusModel: oldBusModel);
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      isSuccess = true;
      BotToast.showText(text: right.message);
    });
    //state = state.update(isLoading: false);
    return isSuccess;
  }

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

  Future<String> uploadBusImage({
    required File file,
    required String directory,
    required String fileName,
  }) async {
    String imageLink = "";
    state = state.update(isLoading: true);
    Either<Failure, String> response = await busRemoteDataSource
        .uploadBusImage(directory: directory, file: file, fileName: fileName);
    response.fold(
          (left) {
        BotToast.showText(text: left.message);
      },
          (right) {
        imageLink = right;
        BotToast.showText(text: "Profile picture uploaded successfully");
      },
    );
    state = state.update(isLoading: false);
    return imageLink;
  }

}
