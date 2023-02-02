import 'package:flutter/material.dart';

class ProfileLogoAsset extends StatelessWidget {
  final String photo;
  final double size;

  const ProfileLogoAsset({required this.photo, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2 - size / 19),
        child: Image(
          image: AssetImage( "assets/img/$photo"),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ));
  }
}
