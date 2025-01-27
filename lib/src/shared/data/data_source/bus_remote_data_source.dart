import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/network/firebase/firestore_collection_name.dart';
import '../../../core/network/responses/failure_response.dart';
import '../../../core/network/responses/success_response.dart';
import '../model/bus_model.dart';

class BusRemoteDataSource {

  Future<Either<Failure, Success>> addBus(
      {required BusModel busModel}) async {
    Failure failure;
    try {
      final docRef = await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.busCollection)
          .doc(busModel.number)
          .set(busModel.toBusJson());

      return Right(Success(message: "Bus Added Successfully"));
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

  Future<Either<Failure, String>> uploadBusImage({
    required File file,
    required String directory,
    required String fileName,
  }) async {
    Failure failure;
    Reference storageRef = FirebaseStorage.instance.ref();
    Reference profileDirectory = storageRef.child(directory).child(fileName);
    try {
      String profileImageUrl;
      await profileDirectory.putFile(file);
      profileImageUrl = await profileDirectory.getDownloadURL();
      return Right(profileImageUrl);
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'object-not-found':
          failure =
              Failure(message: 'No object exists at the desired reference.');
          break;
        case 'unauthorized':
          failure = Failure(
              message: 'User does not have permission to access the object.');
          break;
        case 'cancelled':
          failure = Failure(message: 'User canceled the operation.');
          break;
        case 'unknown':
          failure = Failure(
              message: 'Unknown error occurred, inspect the server response.');
          break;
        default:
          failure = Failure(message: 'Something went wrong: ${e.message}');
          break;
      }
    } catch (e) {
      failure = Failure(message: 'Error: $e');
    }
    return Left(failure);
  }


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
