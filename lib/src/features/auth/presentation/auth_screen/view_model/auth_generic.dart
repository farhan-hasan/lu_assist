class AuthGeneric {
  bool isLoading;

  AuthGeneric({this.isLoading = false});

  AuthGeneric update({bool? isLoading}) {
    return AuthGeneric(isLoading: isLoading ?? this.isLoading);
  }
}
