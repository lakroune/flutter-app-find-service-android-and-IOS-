import 'package:flutter/material.dart';
import 'package:s5/class/post.dart';

class ProfileLogo extends StatelessWidget {
  final String photo;
  final double size;
  final double radius;

  const ProfileLogo({required this.photo, required this.size,this.radius=40});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
           MYURLIMG(photo),
          width: size,
          height: size,
          fit: BoxFit.cover,
        )
        );
  }
}


