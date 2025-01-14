class LoginGeneric {
  bool isLoading;

  LoginGeneric({this.isLoading = false});

  LoginGeneric update({bool? isLoading}) {
    return LoginGeneric(isLoading: isLoading ?? this.isLoading);
  }
}
