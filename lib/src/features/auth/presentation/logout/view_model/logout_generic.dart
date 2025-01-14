class LogoutGeneric {
  bool isLoading;

  LogoutGeneric({this.isLoading = false});

  LogoutGeneric update({bool? isLoading}) {
    return LogoutGeneric(isLoading: isLoading ?? this.isLoading);
  }
}
