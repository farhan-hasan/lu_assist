import '../../../auth/data/model/user_model.dart';

class ProfileGeneric {
  bool isLoading;
  UserModel? userModel;
  ProfileGeneric({this.isLoading = false, this.userModel});

  ProfileGeneric update({bool? isLoading, UserModel? userModel}) {
    return ProfileGeneric(isLoading: isLoading ?? this.isLoading, userModel: userModel);
  }
}
