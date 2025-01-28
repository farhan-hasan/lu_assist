import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/network/responses/success_response.dart';
import 'package:lu_assist/src/features/news_feed/data/data_source/news_feed_remote_data_source.dart';
import 'package:lu_assist/src/features/news_feed/data/model/feed_model.dart';
import 'package:lu_assist/src/features/news_feed/presentation/view_model/news_feed_generic.dart';
import 'package:lu_assist/src/features/profile/presentation/view_model/profile_controller.dart';
import 'package:lu_assist/src/shared/data/data_source/fcm_remote_data_source.dart';
import 'package:lu_assist/src/shared/data/model/push_body_model.dart';

import '../../../../core/network/responses/failure_response.dart';
import '../../../auth/data/model/user_model.dart';


final newsFeedProvider =
StateNotifierProvider<NewsFeedController, NewsFeedGeneric>(
      (ref) => NewsFeedController(ref),
);

class NewsFeedController extends StateNotifier<NewsFeedGeneric> {
  NewsFeedController(this.ref) : super(NewsFeedGeneric());
  Ref ref;
  NewsFeedRemoteDataSource newsFeedRemoteDataSource = NewsFeedRemoteDataSource();
  FCMRemoteDataSource fcmRemoteDataSource = FCMRemoteDataSource();

  Future addPost({
    required String post,
  }) async {
    bool isSuccess = false;
    UserModel? userModel = ref
        .read(profileProvider)
        .userModel;
    FeedModel feedModel = FeedModel();
    feedModel.name = userModel?.name ?? "";
    feedModel.userId = userModel?.id ?? "";
    feedModel.createdAt = DateTime.now();
    feedModel.post = post;
    feedModel.image = userModel?.image;
    state = state.update(isLoading: true);
    Either<Failure, Success> response = await newsFeedRemoteDataSource
        .addPost(feedModel: feedModel);
    response.fold(
          (left) {
        BotToast.showText(text: left.message);
      },
          (right) {
        isSuccess = true;
        BotToast.showText(text: right.message);
      },
    );
    state = state.update(isLoading: false);
    if (isSuccess) {
      PushBodyModel pushBodyModel = PushBodyModel(
          type: "new_post", showNotification: true);
      fcmRemoteDataSource.sendPushMessage(topic: "new_post",
          data: pushBodyModel,
          title: "New Post available",
          body: "${userModel?.name ?? ""} just posted. Tap to check out", imageUrl: '');
    }
  }

  Future deletePost({
    required String feedId,
  }) async {
    state = state.update(isLoading: true);
    Either<Failure, Success> response = await newsFeedRemoteDataSource
        .deletePost(feedId: feedId);
    response.fold(
          (left) {
        BotToast.showText(text: left.message);
      },
          (right) {
        BotToast.showText(text: right.message);
      },
    );
    state = state.update(isLoading: false);
  }


  Future editPost({
    required String feedId,
    required String post
  }) async {
    state = state.update(isLoading: true);
    Either<Failure, Success> response = await newsFeedRemoteDataSource
        .editPost(feedId: feedId, post: post);
    response.fold(
          (left) {
        BotToast.showText(text: left.message);
      },
          (right) {
        BotToast.showText(text: right.message);
      },
    );
    state = state.update(isLoading: false);
  }

  Future<Stream<List<FeedModel>>> getAllPosts() async {
    Stream<List<FeedModel>> response = await newsFeedRemoteDataSource
        .getAllPosts();
    return response;
  }


}
