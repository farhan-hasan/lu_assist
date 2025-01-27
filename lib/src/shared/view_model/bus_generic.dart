class BusGeneric {
  bool isLoading;

  BusGeneric({this.isLoading = false});

  BusGeneric update(
      {bool? isLoading}) {
    return BusGeneric(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
