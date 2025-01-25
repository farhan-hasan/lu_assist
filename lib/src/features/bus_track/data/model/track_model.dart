class TrackModel {
  String? pointName;
  bool? arrived;
  DateTime? arrivedAt;

  // Constructor
  TrackModel({
    this.pointName,
    this.arrived,
    this.arrivedAt,
  });

  // Factory constructor for creating an instance from JSON
  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      pointName: json['pointName'] as String?,
      arrived: json['arrived'] as bool?,
      arrivedAt: json['arrivedAt'] != null
          ? DateTime.parse(json['arrivedAt'] as String)
          : null,
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'pointName': pointName,
      'arrived': arrived,
      'arrivedAt': arrivedAt?.toIso8601String(),
    };
  }
}
