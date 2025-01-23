import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/firebase/firestore_collection_name.dart';
import '../../../../core/network/responses/failure_response.dart';
import '../../../../core/network/responses/success_response.dart';
import '../model/user_model.dart';


class AuthRemoteDataSource {
  Future<Either<Failure, User>> signUp(
      {required String email, required String password}) async {
    Failure failure;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      return Right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          failure = Failure(
              message:
              'The email address is already in use by another account.');
          break;
        case 'invalid-email':
          failure = Failure(message: 'The email address is not valid.');
          break;
        case 'operation-not-allowed':
          failure =
              Failure(message: 'Email/password accounts are not enabled.');
          break;
        case 'weak-password':
          failure = Failure(message: 'The password is too weak.');
          break;
        case 'too-many-requests':
          failure =
              Failure(message: 'Too many requests. Please try again later.');
          break;
        case 'network-request-failed':
          failure =
              Failure(message: 'Network error. Please check your connection.');
          break;
        case 'user-token-expired':
          failure = Failure(
              message: 'Your session has expired. Please log in again.');
          break;
        default:
          failure = Failure(message: 'An unknown error occurred.');
          break;
      }
    }
    return Left(failure);
  }

  Future<Either<Failure, User>> login(
      {required String email, required String password}) async {
    Failure failure;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!userCredential.user!.emailVerified) {
        // If email is not verified, return failure
        failure = Failure(
            message: 'Email is not verified. Please verify your email.');
        return Left(failure);
      }
      return Right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          failure = Failure(message: 'The email address is not valid.');
          break;
        case 'user-disabled':
          failure = Failure(message: 'This user has been disabled.');
          break;
        case 'user-not-found':
          failure = Failure(message: 'No user found for that email.');
          break;
        case 'wrong-password':
          failure = Failure(message: 'Incorrect password. Please try again.');
          break;
        case 'too-many-requests':
          failure =
              Failure(message: 'Too many requests. Please try again later.');
          break;
        case 'network-request-failed':
          failure =
              Failure(message: 'Network error. Please check your connection.');
          break;
        case 'user-token-expired':
          failure = Failure(
              message: 'Your session has expired. Please log in again.');
          break;
        case 'operation-not-allowed':
          failure =
              Failure(message: 'Email/password accounts are not enabled.');
          break;
        case 'invalid-credential':
          failure = Failure(message: 'Invalid login credentials.');
          break;
        default:
          failure = Failure(message: 'An unknown error occurred.');
          break;
      }
    }
    return Left(failure);
  }

  Future<Either<Failure, Success>> logout() async {
    Failure failure;
    try {
      await FirebaseAuth.instance.signOut();
      return Right(Success(message: "Logout successful"));
    } catch (e) {
      failure = Failure(message: "An unknown error occurred.");
    }
    return Left(failure);
  }
}