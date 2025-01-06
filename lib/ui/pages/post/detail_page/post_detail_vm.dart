import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailModel {
  Post post;

  PostDetailModel.fromMap(Map<String, dynamic> map) : post = Post.fromMap(map);
}

// autoDispose 화면 파괴시에 창고 같이 소멸함
final postDetailProvider = NotifierProvider.autoDispose
    .family<PostDetailVM, PostDetailModel?, int>(() {
  return PostDetailVM();
});

class PostDetailVM extends AutoDisposeFamilyNotifier<PostDetailModel?, int> {
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostDetailModel? build(id) {
    init(id);
    return null;
  }

  Future<void> init(int id) async {
    Map<String, dynamic> responseBody = await postRepository.findById(id);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 상세보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    PostDetailModel model = PostDetailModel.fromMap(responseBody["response"]);
    state = model;
  }

  Future<void> deleteById(int id) async {
    Map<String, dynamic> responseBody = await postRepository.delete(id);
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 삭제 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    // PostlistVM의 상태를 변경
    //ref.read(postListProvider.notifier).init(0);
    ref.read(postListProvider.notifier).remove(id);

    // EventBus Notifier -> 삭제했어!!

    // 화면 파괴시 vm이 autoDispose 됨
    //Navigator.pop(mContext);
    Navigator.pop(mContext);
  }
}
