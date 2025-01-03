import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailModel {
  Post? post;
}

final postDetailProvider = NotifierProvider<PostDetailVM, PostDetailModel?>(() {
  return PostDetailVM();
});

class PostDetailVM extends Notifier<PostDetailModel?> {
  @override
  PostDetailModel? build() {
    init();
    return null;
  }

  Future<void> init() async {}
}
