import 'package:flutter/material.dart';

class ProfilPic extends StatelessWidget {
  const ProfilPic({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 115,
          width: 115,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/avataar.jpg"),
          ),
        ),
      ],
    );
  }
}
