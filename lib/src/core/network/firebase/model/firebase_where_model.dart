class FirebaseWhereModel {
  String field;
  Object? isEqualTo;
  Object? isNotEqualTo;
  Object? isLessThan;
  Object? isLessThanOrEqualTo;
  Object? isGreaterThan;
  Object? isGreaterThanOrEqualTo;
  Object? arrayContains;
  Iterable<Object?>? arrayContainsAny;
  Iterable<Object?>? whereIn;
  Iterable<Object?>? whereNotIn;
  bool? isNull;

  FirebaseWhereModel({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });

  // From JSON
  factory FirebaseWhereModel.fromJson(Map<String, dynamic> json) {
    return FirebaseWhereModel(
      field: json['field'],
      isEqualTo: json['isEqualTo'],
      isNotEqualTo: json['isNotEqualTo'],
      isLessThan: json['isLessThan'],
      isLessThanOrEqualTo: json['isLessThanOrEqualTo'],
      isGreaterThan: json['isGreaterThan'],
      isGreaterThanOrEqualTo: json['isGreaterThanOrEqualTo'],
      arrayContains: json['arrayContains'],
      arrayContainsAny: json['arrayContainsAny']?.cast<Object>(),
      whereIn: json['whereIn']?.cast<Object>(),
      whereNotIn: json['whereNotIn']?.cast<Object>(),
      isNull: json['isNull'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'isEqualTo': isEqualTo,
      'isNotEqualTo': isNotEqualTo,
      'isLessThan': isLessThan,
      'isLessThanOrEqualTo': isLessThanOrEqualTo,
      'isGreaterThan': isGreaterThan,
      'isGreaterThanOrEqualTo': isGreaterThanOrEqualTo,
      'arrayContains': arrayContains,
      'arrayContainsAny': arrayContainsAny?.toList(),
      'whereIn': whereIn?.toList(),
      'whereNotIn': whereNotIn?.toList(),
      'isNull': isNull,
    };
  }
}
