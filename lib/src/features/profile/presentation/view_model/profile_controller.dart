import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/features/profile/presentation/view_model/profile_generic.dart';

import '../../../../core/network/responses/failure_response.dart';
import '../../../auth/data/data_source/remote/auth_remote_data_source.dart';
import '../../../auth/data/model/user_model.dart';
import '../../data/data_source/remote/profile_remote_data_source.dart';

final profileProvider = StateNotifierProvider<ProfileController, ProfileGeneric>(
      (ref) => ProfileController(ref),
);

class ProfileController extends StateNotifier<ProfileGeneric> {
  ProfileController(this.ref) : super(ProfileGeneric());
  Ref ref;
  ProfileRemoteDataSource profileRemoteDataSource = ProfileRemoteDataSource();

  Future createProfile({
    required UserModel userModel,
  }) async {
    Either<Failure, UserModel> response = await profileRemoteDataSource.createProfile(userModel: userModel);
    response.fold(
          (left) {
        BotToast.showText(text: left.message);
      },
          (right) {
        BotToast.showText(text: "Profile Created Successfully");
      },
    );
  }


  Future readProfile(String uid) async {
    state = state.update(isLoading: true);
    Either<Failure, UserModel> response =
    await profileRemoteDataSource.readProfile(uid: uid);
    response.fold((left) {
      BotToast.showText(text: left.message);
    }, (right) {
      BotToast.showText(text: "Profile read Successfully");
      state = state.update(userModel: right);
    });
    state = state.update(isLoading: false);
  }


  Future updateProfile(UserModel userModel) async {
    Either<Failure, UserModel> response =
    await profileRemoteDataSource.updateProfile(userModel: userModel);
    response.fold(
          (left) {
        BotToast.showText(text: left.message);
      },
          (right) {
        BotToast.showText(text: "Profile Updated Successfully");
      },
    );
  }






}
