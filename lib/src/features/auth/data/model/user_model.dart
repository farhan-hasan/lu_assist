class UserModel {
  int batch;
  String department;
  String email;
  String id;
  String image;
  String name;
  int route;
  String section;
  int studentId;
  String role;
  String deviceToken;

  // Constructor
  UserModel({
    required this.batch,
    required this.department,
    required this.email,
    required this.id,
    required this.image,
    required this.name,
    required this.route,
    required this.section,
    required this.studentId,
    required this.role,
    required this.deviceToken,
  });

  // Factory method to create a Student object from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      batch: json['batch'],
      department: json['department'],
      email: json['email'],
      id: json['id'],
      image: json['image'],
      name: json['name'],
      route: json['route'],
      section: json['section'],
      studentId: json['student_id'],
      role: json['role'],
      deviceToken: json['deviceToken'],
    );
  }

  // Method to convert a Student object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'batch': batch,
      'department': department,
      'email': email,
      'id': id,
      'image': image,
      'name': name,
      'route': route,
      'section': section,
      'student_id': studentId,
      'role': role,
      'deviceToken': deviceToken,
    };
  }
}
