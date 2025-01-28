import '../../data/model/bus_model.dart';

class BusGeneric {
  bool isLoading;
  List<BusModel>? busList;

  BusGeneric({this.isLoading = false, this.busList});

  BusGeneric update(
      {bool? isLoading,
        List<BusModel>? busList,}) {
    return BusGeneric(
      isLoading: isLoading ?? this.isLoading,
      busList: busList ?? this.busList,
    );
  }
}
