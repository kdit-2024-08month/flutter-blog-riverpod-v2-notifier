import 'package:flutter/material.dart';

class PostDetailContent extends StatelessWidget {
  String content;

  PostDetailContent(this.content);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(content),
    );
  }
}
