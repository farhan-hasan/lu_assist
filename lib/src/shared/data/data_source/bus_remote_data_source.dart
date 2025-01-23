import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../core/network/firebase/firestore_collection_name.dart';
import '../../../core/network/responses/failure_response.dart';
import '../../../core/network/responses/success_response.dart';
import '../model/bus_model.dart';

class BusRemoteDataSource {
  Future<Either<Failure, List<BusModel>>> getAllBuses() async {
    Failure failure;
    List<BusModel> busList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(FirestoreCollectionName.busCollection)
              .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        busList.add(BusModel.fromBusJson(doc.data() as Map<String, dynamic>));
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

  Future<Either<Failure, Success>> toggleBusAllocation(
      {required BusModel busModel}) async {
    Failure failure;
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.busCollection)
          .doc(busModel.number)
          .update(busModel.toBusJson());

      return Right(Success(message: "Allocation toggled Successfully"));
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
