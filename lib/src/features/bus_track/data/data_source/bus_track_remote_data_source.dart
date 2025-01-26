import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:lu_assist/src/core/network/firebase/firestore_document_name.dart';
import 'package:lu_assist/src/shared/data/model/bus_model.dart';

import '../../../../core/network/firebase/firestore_collection_name.dart';
import '../../../../core/network/responses/failure_response.dart';
import '../../../../core/network/responses/success_response.dart';

class BusTrackRemoteDataSource {
  // Future<Stream<List<TrackModel>>> trackRouteOne() async {
  //   Failure failure;
  //   try {
  //     Stream<List<TrackModel>> querySnapshot = FirebaseFirestore.instance
  //         .collection(FirestoreCollectionName.routeCollection)
  //     .doc(FirestoreDocumentname.routeOneDocument).collection(FirestoreCollectionName.busTrackCollection)
  //         .snapshots()
  //         .map((documentList) {
  //       return documentList.docs
  //           .map((r) => TrackModel.fromJson(r.data()))
  //           .toList();
  //     });
  //     return querySnapshot;
  //   } on FirebaseException catch (e) {
  //     switch (e.code) {
  //       case 'permission-denied':
  //         failure = Failure(message: "Handle permission denied error");
  //         break;
  //       case 'not-found':
  //         failure = Failure(message: "Handle document not found error");
  //         break;
  //       default:
  //         failure = Failure(message: "An unknown error occured");
  //         break;
  //     }
  //   }
  //   return Stream.value([]);
  // }
  //
  // Future<Stream<List<TrackModel>>> trackRouteTwo() async {
  //   Failure failure;
  //   try {
  //     Stream<List<TrackModel>> querySnapshot = FirebaseFirestore.instance
  //         .collection(FirestoreCollectionName.routeCollection)
  //         .doc(FirestoreDocumentname.routeTwoDocument).collection(FirestoreCollectionName.busTrackCollection)
  //         .snapshots()
  //         .map((documentList) {
  //       return documentList.docs
  //           .map((r) => TrackModel.fromJson(r.data()))
  //           .toList();
  //     });
  //     return querySnapshot;
  //   } on FirebaseException catch (e) {
  //     switch (e.code) {
  //       case 'permission-denied':
  //         failure = Failure(message: "Handle permission denied error");
  //         break;
  //       case 'not-found':
  //         failure = Failure(message: "Handle document not found error");
  //         break;
  //       default:
  //         failure = Failure(message: "An unknown error occured");
  //         break;
  //     }
  //   }
  //   return Stream.value([]);
  // }
  //
  // Future<Stream<List<TrackModel>>> trackRouteThree() async {
  //   Failure failure;
  //   try {
  //     Stream<List<TrackModel>> querySnapshot = FirebaseFirestore.instance
  //         .collection(FirestoreCollectionName.routeCollection)
  //         .doc(FirestoreDocumentname.routeThreeDocument).collection(FirestoreCollectionName.busTrackCollection)
  //         .snapshots()
  //         .map((documentList) {
  //       return documentList.docs
  //           .map((r) => TrackModel.fromJson(r.data()))
  //           .toList();
  //     });
  //     return querySnapshot;
  //   } on FirebaseException catch (e) {
  //     switch (e.code) {
  //       case 'permission-denied':
  //         failure = Failure(message: "Handle permission denied error");
  //         break;
  //       case 'not-found':
  //         failure = Failure(message: "Handle document not found error");
  //         break;
  //       default:
  //         failure = Failure(message: "An unknown error occured");
  //         break;
  //     }
  //   }
  //   return Stream.value([]);
  // }
  //
  // Future<Stream<List<TrackModel>>> trackRouteFour() async {
  //   Failure failure;
  //   try {
  //     Stream<List<TrackModel>> querySnapshot = FirebaseFirestore.instance
  //         .collection(FirestoreCollectionName.routeCollection)
  //         .doc(FirestoreDocumentname.routeFourDocument).collection(FirestoreCollectionName.busTrackCollection)
  //         .snapshots()
  //         .map((documentList) {
  //       return documentList.docs
  //           .map((r) => TrackModel.fromJson(r.data()))
  //           .toList();
  //     });
  //     return querySnapshot;
  //   } on FirebaseException catch (e) {
  //     switch (e.code) {
  //       case 'permission-denied':
  //         failure = Failure(message: "Handle permission denied error");
  //         break;
  //       case 'not-found':
  //         failure = Failure(message: "Handle document not found error");
  //         break;
  //       default:
  //         failure = Failure(message: "An unknown error occured");
  //         break;
  //     }
  //   }
  //   return Stream.value([]);
  // }

  Future<Stream<List<BusModel>>> listenRouteOneBusSchedule() async {
    Failure failure;
    try {
      Stream<List<BusModel>> querySnapshot = FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(FirestoreDocumentname.routeOneDocument)
          .collection(FirestoreCollectionName.busScheduleCollection)
          .snapshots()
          .map((documentList) {
        return documentList.docs
            .map((r) => BusModel.fromJson(r.data()))
            .toList();
      });
      return querySnapshot;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Stream.value([]);
  }

  Future<Stream<List<BusModel>>> listenRouteTwoBusSchedule() async {
    Failure failure;
    try {
      Stream<List<BusModel>> querySnapshot = FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(FirestoreDocumentname.routeTwoDocument)
          .collection(FirestoreCollectionName.busScheduleCollection)
          .snapshots()
          .map((documentList) {
        return documentList.docs
            .map((r) => BusModel.fromJson(r.data()))
            .toList();
      });
      return querySnapshot;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Stream.value([]);
  }

  Future<Stream<List<BusModel>>> listenRouteThreeBusSchedule() async {
    Failure failure;
    try {
      Stream<List<BusModel>> querySnapshot = FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(FirestoreDocumentname.routeThreeDocument)
          .collection(FirestoreCollectionName.busScheduleCollection)
          .snapshots()
          .map((documentList) {
        return documentList.docs
            .map((r) => BusModel.fromJson(r.data()))
            .toList();
      });
      return querySnapshot;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Stream.value([]);
  }

  Future<Stream<List<BusModel>>> listenRouteFourBusSchedule() async {
    Failure failure;
    try {
      Stream<List<BusModel>> querySnapshot = FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(FirestoreDocumentname.routeFourDocument)
          .collection(FirestoreCollectionName.busScheduleCollection)
          .snapshots()
          .map((documentList) {
        return documentList.docs
            .map((r) => BusModel.fromJson(r.data()))
            .toList();
      });
      return querySnapshot;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Stream.value([]);
  }

  Future<Either<Failure, Success>> updateBusLocation(
      {required String arrivalPoint, required DateTime arrivalTime, required String busNumber, required String route}) async {
    Failure failure;
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(route.replaceAll(' ', '')
              .toUpperCase())
          .collection(FirestoreCollectionName
              .busScheduleCollection)
          .doc(busNumber)
          .update({"arrivalPoint" : arrivalPoint, "arrivalTime" : arrivalTime.toIso8601String()});

      return Right(Success(message: "Updated Schedule Successfully"));
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Left(failure);
  }
}
