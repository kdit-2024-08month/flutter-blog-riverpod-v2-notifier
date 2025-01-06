import 'package:flutter/material.dart';

class PostDetailTitle extends StatelessWidget {
  String title;

  PostDetailTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
    );
  }
}

