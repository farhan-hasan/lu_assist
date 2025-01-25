
class BusTrackGeneric {
  bool isLoading;

  BusTrackGeneric({this.isLoading = false});

  BusTrackGeneric update(
      {bool? isLoading}) {
    return BusTrackGeneric(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
