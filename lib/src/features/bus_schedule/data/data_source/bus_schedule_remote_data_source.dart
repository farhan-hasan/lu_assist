import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:lu_assist/src/core/network/firebase/firestore_document_name.dart';

import '../../../../core/network/firebase/firestore_collection_name.dart';
import '../../../../core/network/responses/failure_response.dart';
import '../../../../core/network/responses/success_response.dart';
import '../../../bus_list/data/model/bus_model.dart';

class BusScheduleRemoteDataSource {
  Future<Either<Failure, Success>> createSchedule(
      {required BusModel busModel}) async {
    Failure failure;
    try {
      final docRef = await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(busModel.route?.replaceAll(' ', '').toUpperCase())
          .collection(FirestoreCollectionName.busScheduleCollection)
          .doc(busModel.number)
          .set(busModel.toJson());

      return Right(Success(message: "Created Schedule Successfully"));
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

  Future<Either<Failure, Success>> deleteSchedule(
      {required BusModel busModel}) async {
    Failure failure;
    try {
      final docRef = await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(busModel.route?.replaceAll(' ', '').toUpperCase())
          .collection(FirestoreCollectionName.busScheduleCollection)
          .doc(busModel.number)
          .delete();
      return Right(Success(message: "Deleted Schedule Successfully"));
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

  Future<Either<Failure, Success>> updateSchedule(
      {required BusModel busModel, required BusModel oldBusModel}) async {
    Failure failure;
    try {

      // Delete the old document
      await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(oldBusModel.route?.replaceAll(' ', '').toUpperCase())
          .collection(FirestoreCollectionName.busScheduleCollection)
          .doc(oldBusModel.number)
          .delete();

      // Create a new document with the desired ID and updated data
      await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(busModel.route?.replaceAll(' ', '').toUpperCase())
          .collection(FirestoreCollectionName.busScheduleCollection)
          .doc(busModel.number)
          .set(busModel.toJson());

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

  Future<Either<Failure, List<BusModel>>> getAllBusSchedule() async {
    List<BusModel> busList = [];
    Failure failure;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(FirestoreCollectionName.routeCollection)
              .doc(FirestoreDocumentname.routeOneDocument)
              .collection(FirestoreCollectionName.busScheduleCollection)
              .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        busList.add(BusModel.fromJson(doc.data() as Map<String, dynamic>));
      }

      querySnapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(FirestoreDocumentname.routeTwoDocument)
          .collection(FirestoreCollectionName.busScheduleCollection)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        busList.add(BusModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      querySnapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(FirestoreDocumentname.routeThreeDocument)
          .collection(FirestoreCollectionName.busScheduleCollection)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        busList.add(BusModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      querySnapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.routeCollection)
          .doc(FirestoreDocumentname.routeFourDocument)
          .collection(FirestoreCollectionName.busScheduleCollection)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        busList.add(BusModel.fromJson(doc.data() as Map<String, dynamic>));
      }

      return Right(busList);
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
