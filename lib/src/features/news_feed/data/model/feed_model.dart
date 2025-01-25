class FeedModel {
  String? id;
  String? userId;
  String? name;
  String? post;
  DateTime? createdAt;
  String? image;

  // Constructor
  FeedModel({
    this.id,
    this.userId,
    this.name,
    this.post,
    this.createdAt,
    this.image,
  });

  // fromJson factory method
  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      post: json['post'] as String?,
      image: json['image'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'post': post,
      'image': image,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
