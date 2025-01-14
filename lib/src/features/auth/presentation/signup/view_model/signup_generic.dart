class SignupGeneric {
  bool isLoading;

  SignupGeneric({this.isLoading = false});

  SignupGeneric update({bool? isLoading}) {
    return SignupGeneric(isLoading: isLoading ?? this.isLoading);
  }
}
