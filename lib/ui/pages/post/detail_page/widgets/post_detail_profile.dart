import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/model/post.dart';

class PostDetailProfile extends StatelessWidget {
  Post post;
  PostDetailProfile(this.post);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text("${post.user!.username!}"),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network('$baseUrl${post.user!.imgUrl!}', fit: BoxFit.cover),
        ),
        subtitle: const Text("Written on May 25"),
    );
  }
}
