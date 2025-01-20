import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/network/firebase/firestore_collection_name.dart';
import '../../../../../core/network/responses/failure_response.dart';
import '../../../../auth/data/model/user_model.dart';

class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> createProfile({
    required UserModel userModel,
  }) async {
    Failure failure;
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.userCollection)
          .doc(userModel.id)
          .set(userModel.toJson());
      return Right(userModel);
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

  Future<Either<Failure, UserModel>> readProfile(
      {required String uid}) async {
    Failure failure;
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.userCollection)
          .doc(uid)
          .get();
      return Right(UserModel.fromJson(documentSnapshot.data() ?? {}));
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occurred");
          break;
      }
    }
    return Left(failure);
  }

  Future<Either<Failure, UserModel>> updateProfile(
      {required UserModel userModel}) async {
    Failure failure;
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollectionName.userCollection)
          .doc(userModel.id)
          .update(userModel.toJson());
      return Right(userModel);
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occurred");
          break;
      }
    }
    return Left(failure);
  }





}