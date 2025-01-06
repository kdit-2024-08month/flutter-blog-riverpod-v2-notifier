import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}
