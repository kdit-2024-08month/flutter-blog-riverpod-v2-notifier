import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postEventBusProvider = NotifierProvider<PostEventBus, PostEvent>(() {
  return PostEventBus();
});

class PostEvent {
  final int? deletedPostId;
  final Post? updatedPost;

  PostEvent({this.deletedPostId, this.updatedPost});
}

class PostEventBus extends Notifier<PostEvent> {
  @override
  PostEvent build() {
    return PostEvent();
  }

  void postDeleted(int postId) {
    state = PostEvent(deletedPostId: postId);
  }

  void postUpdated(Post updatedPost) {
    state = PostEvent(updatedPost: updatedPost);
  }
}
