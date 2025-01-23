
import 'package:bot_toast/bot_toast.dart';
import 'package:lu_assist/src/core/network/responses/failure_response.dart';
import 'package:lu_assist/src/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:lu_assist/src/features/auth/presentation/signup/view_model/signup_generic.dart';
import 'package:lu_assist/src/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:lu_assist/src/shared/dependency_injection/dependency_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/network/firebase/firestore_collection_name.dart';
import '../../../data/model/user_model.dart';

final signUpProvider = StateNotifierProvider<SignupController, SignupGeneric>(
  (ref) => SignupController(ref),
);

class SignupController extends StateNotifier<SignupGeneric> {
  SignupController(this.ref) : super(SignupGeneric());
  Ref ref;
  AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();
  ProfileRemoteDataSource profileRemoteDataSource = ProfileRemoteDataSource();

  Future<String> signUp(
      {required String email, required String password}) async {
    state = state.update(isLoading: true);
    String uid = "";
    Either<Failure, User> response = await authRemoteDataSource.signUp(email: email,password: password);
    response.fold(
          (left) {
        BotToast.showText(text: left.message);
      },
          (right) {
        BotToast.showText(text: "Signup successful.");
        uid = right.uid;
      },
    );
    state = state.update(isLoading: false);
    return uid;
  }






}
