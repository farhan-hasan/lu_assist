import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/features/bus_track/data/data_source/bus_track_remote_data_source.dart';
import 'package:lu_assist/src/features/bus_track/presentation/view_model/bus_track_generic.dart';
import 'package:lu_assist/src/shared/data/data_source/bus_remote_data_source.dart';
import 'package:lu_assist/src/shared/data/model/bus_model.dart';

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
    Stream<List<BusModel>> response = await busTrackRemoteDataSource.listenRouteOneBusSchedule();
    return response;
  }


}
