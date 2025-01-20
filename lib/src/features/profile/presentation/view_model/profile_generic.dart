import '../../../auth/data/model/user_model.dart';

class ProfileGeneric {
  bool isLoading;
  bool isProfilePictureLoading;
  UserModel? userModel;

  ProfileGeneric({this.isLoading = false, this.userModel, this.isProfilePictureLoading = false});

  ProfileGeneric update({bool? isLoading, UserModel? userModel, bool? isProfilePictureLoading,}) {
    return ProfileGeneric(
        isLoading: isLoading ?? this.isLoading,
        isProfilePictureLoading: isProfilePictureLoading ?? this.isProfilePictureLoading,
        userModel: userModel ?? this.userModel);
  }
}
