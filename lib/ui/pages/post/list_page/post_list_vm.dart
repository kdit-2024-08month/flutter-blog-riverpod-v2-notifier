import 'package:flutter/material.dart';
import 'package:flutter_blog/data/gvm/post_event_bus_gvm.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class PostListModel {
  bool isFirst;
  bool isLast;
  int pageNumber;
  int size;
  int totalPage;
  List<Post> posts;

  PostListModel(
      {required this.isFirst,
      required this.isLast,
      required this.pageNumber,
      required this.size,
      required this.totalPage,
      required this.posts});

  PostListModel copyWith(
      {bool? isFirst,
      bool? isLast,
      int? pageNumber,
      int? size,
      int? totalPage,
      List<Post>? posts}) {
    return PostListModel(
        isFirst: isFirst ?? this.isFirst,
        isLast: isLast ?? this.isLast,
        pageNumber: pageNumber ?? this.pageNumber,
        size: size ?? this.size,
        totalPage: totalPage ?? this.totalPage,
        posts: posts ?? this.posts);
  }

  PostListModel.fromMap(Map<String, dynamic> map)
      : isFirst = map["isFirst"],
        isLast = map["isLast"],
        pageNumber = map["pageNumber"],
        size = map["size"],
        totalPage = map["totalPage"],
        posts = (map["posts"] as List<dynamic>)
            .map((e) => Post.fromMap(e))
            .toList();
}

final postListProvider = NotifierProvider<PostListVM, PostListModel?>(() {
  return PostListVM();
});

class PostListVM extends Notifier<PostListModel?> {
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostListModel? build() {
    init(0);

    ref.listen<PostEvent>(postEventBusProvider, (previous, next) {
      if (next.deletedPostId != null) {
        Logger().d("삭제 수신함 event 발생 ${next.deletedPostId}");
        remove(next.deletedPostId!);
      }
      if (next.updatedPost != null) {
        update(next.updatedPost!);
      }
    });

    return null;
  }

  Future<void> init(int page) async {
    Map<String, dynamic> responseBody =
        await postRepository.findAll(page: page);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 목록보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    state = PostListModel.fromMap(responseBody["response"]);
  }

  void remove(int id) {
    PostListModel model = state!;

    model.posts = model.posts.where((p) => p.id != id).toList();

    state = state!.copyWith(posts: model.posts);
  }

  void add(Post post) {
    PostListModel model = state!;

    model.posts = [post, ...model.posts];

    state = state!.copyWith(posts: model.posts);
  }

  void update(Post updatedPost) {
    PostListModel model = state!;

    List<Post> updatedPosts = model.posts.map((post) {
      if (post.id == updatedPost.id) {
        return updatedPost; // 수정된 게시글로 교체
      }
      return post; // 나머지는 그대로 유지
    }).toList();

    state = state!.copyWith(posts: updatedPosts); // 리스트 복사로 상태 반영
  }
}
