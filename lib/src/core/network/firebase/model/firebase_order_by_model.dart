class FirebaseOrderByModel {
  Object field;
  bool descending;

  FirebaseOrderByModel({
    required this.field,
    this.descending = false,
  });

  // From JSON
  factory FirebaseOrderByModel.fromJson(Map<String, dynamic> json) {
    return FirebaseOrderByModel(
      field: json['field'],
      descending: json['descending'] ?? false,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'descending': descending,
    };
  }
}
