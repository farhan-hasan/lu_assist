class PushBodyModel {
  String type;
  String body;
  bool showNotification;

  // Constructor
  PushBodyModel(
      {required this.type, this.body = "", this.showNotification = true});

  // Convert a PushBodyModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'body': body,
    };
  }

  // Create a PushBodyModel object from a JSON map
  factory PushBodyModel.fromJson(Map<String, dynamic> json) {
    return PushBodyModel(
      type: json['type'] as String,
      body: json['body'] as String,
    );
  }
}
