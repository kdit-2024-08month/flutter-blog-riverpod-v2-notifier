import 'package:flutter_blog/data/model/user.dart';
import 'package:intl/intl.dart';

class Post {
  int? id;
  String? title;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? bookmarkCount;
  bool? isBookmark;
  User? user;

  Post.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        content = map["content"],
        createdAt = DateFormat("yyyy-mm-dd").parse(map["createdAt"]),
        updatedAt = DateFormat("yyyy-mm-dd").parse(map["createdAt"]),
        bookmarkCount = map["bookmarkCount"],
        isBookmark = map["isBookmark"],
        user = User.fromMap(map["user"]);
}
