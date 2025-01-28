class BusModel {
  String? number;
  String? type;
  bool? incoming;
  bool? allocated;
  String? time;
  String? day;
  String? route;
  String? image;
  String? arrivalPoint;
  DateTime? arrivalTime;

  // Constructor
  BusModel({
    this.number,
    this.type,
    this.incoming,
    this.time,
    this.day,
    this.route,
    this.image,
    this.allocated,
    this.arrivalPoint,
    this.arrivalTime,
  });

  // Factory constructor to create a BusModel from JSON
  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      number: json['number'] as String?,
      type: json['type'] as String?,
      incoming: json['incoming'] as bool?,
      allocated: json['allocated'] as bool?,
      time: json['time'] as String?,
      day: json['day'] as String?,
      route: json['route'] as String?,
      image: json['image'] as String?,
      arrivalPoint: json['arrivalPoint'] as String?,
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'] as String)
          : null,
    );
  }

  factory BusModel.fromBusJson(Map<String, dynamic> json) {
    return BusModel(
      number: json['number'] as String?,
      type: json['type'] as String?,
      allocated: json['allocated'] as bool?,
      image: json['image'] as String?,
    );
  }

  // Method to convert a BusModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'type': type,
      'incoming': incoming,
      'allocated': allocated,
      'time': time,
      'day': day,
      'route': route,
      'image': image,
      'arrivalPoint': arrivalPoint,
      'arrivalTime': arrivalTime?.toIso8601String(),
    };
  }

  Map<String, dynamic> toBusJson() {
    return {
      'number': number,
      'type': type,
      'allocated': allocated,
      'image': image,
    };
  }
}
