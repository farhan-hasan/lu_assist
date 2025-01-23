import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/network/firebase/firestore_collection_name.dart';
import '../../../../core/network/responses/failure_response.dart';
import '../../../../core/network/responses/success_response.dart';
import '../../../auth/data/model/user_model.dart';

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

  Future<Either<Failure, String>> uploadImage({
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





}