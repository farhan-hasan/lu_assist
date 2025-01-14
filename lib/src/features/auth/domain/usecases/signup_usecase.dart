import 'package:dartz/dartz.dart';
import 'package:lu_assist/src/core/network/responses/failure_response.dart';
import 'package:lu_assist/src/core/network/responses/success_response.dart';
import 'package:lu_assist/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:lu_assist/src/features/auth/domain/dto/signup_dto.dart';
import 'package:lu_assist/src/features/auth/domain/repository/auth_repository.dart';
import 'package:lu_assist/src/shared/dependency_injection/dependency_injection.dart';
import 'package:lu_assist/src/shared/domain/use_cases/base_use_case.dart';

class SignupUseCase extends UseCase<Either<Failure, Success>, SignupDto> {
  final AuthRepository _authRepository = sl.get<AuthRepositoryImpl>();
  @override
  Future<Either<Failure, Success>> call(SignupDto params) async {
    return await _authRepository.signUp(
        email: params.email, password: params.password);
  }
}
