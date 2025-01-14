import 'package:flutter/material.dart';

class CircularDisplayPicture extends StatelessWidget {
  CircularDisplayPicture(
      {super.key, required this.imageURL, required this.radius});
  //TODO: make image url dynamic
  final String? imageURL;
  final String dummyImage =
      "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg";
  double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.network(
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          (imageURL == "" || imageURL == null) ? dummyImage : imageURL ?? "",
          // imageURL ?? dummyImage,
        ),
      ),
    );
  }
}
