import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/model/post.dart';

class PostListItem extends StatelessWidget {
  Post post;

  PostListItem(this.post);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text("${post.title}", style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        "${post.content}",
        style: TextStyle(color: Colors.black45),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(50), // 네모난 이미지를 동그랗게 만들기 위한 값 설정
        child: Image.network('$baseUrl${post.user!.imgUrl}'), // 네모난 이미지
      ),
    );
  }
}
