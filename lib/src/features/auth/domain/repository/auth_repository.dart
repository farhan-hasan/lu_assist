import 'package:dartz/dartz.dart';
import 'package:lu_assist/src/core/network/responses/failure_response.dart';
import 'package:lu_assist/src/core/network/responses/success_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, Success>> login(
      {required String email, required String password});
  Future<Either<Failure, Success>> signUp(
      {required String email, required String password});
  Future<Either<Failure, Success>> logout();
  Future<Either<Failure, Success>> changePassword({required String password});
  Future<Either<Failure, Success>> forgotPassword({required String email});
  Future<Either<Failure, Success>> updateEmail({required String email});
}
