import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:lu_assist/src/features/news_feed/data/model/feed_model.dart';

import '../../../../core/network/firebase/firestore_collection_name.dart';
import '../../../../core/network/responses/failure_response.dart';
import '../../../../core/network/responses/success_response.dart';

class NewsFeedRemoteDataSource {
  Future<Either<Failure, Success>> addPost(
      {required FeedModel feedModel}) async {
    Failure failure;
    try {
      final docRef = FirebaseFirestore.instance
          .collection(FirestoreCollectionName.feedCollection)
          .doc();
      feedModel.id = docRef.id;
      await docRef
          .set(feedModel.toJson());
      return Right(Success(message: "Added Post Successfully"));
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Left(failure);
  }

  Future<Either<Failure, Success>> deletePost(
      {required String feedId}) async {
    Failure failure;
    try {
      final docRef = FirebaseFirestore.instance
          .collection(FirestoreCollectionName.feedCollection)
          .doc(feedId);
      await docRef
          .delete();
      return Right(Success(message: "Deleted Post Successfully"));
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Left(failure);
  }

  Future<Either<Failure, Success>> editPost(
      {required String feedId, required String post}) async {
    Failure failure;
    try {
      final docRef = FirebaseFirestore.instance
          .collection(FirestoreCollectionName.feedCollection)
          .doc(feedId);
      await docRef
          .update({'post' : post});
      return Right(Success(message: "Updated Post Successfully"));
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Left(failure);
  }

  Future<Stream<List<FeedModel>>> getAllPosts() async {
    Failure failure;
    try {
      Stream<List<FeedModel>> querySnapshot = FirebaseFirestore.instance
          .collection(FirestoreCollectionName.feedCollection)
          .snapshots()
          .map((documentList) {
        return documentList.docs
            .map((r) => FeedModel.fromJson(r.data()))
            .toList();
      });
      // debug("From Remote Data Source: ${querySnapshot.runtimeType}");
      return querySnapshot;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          failure = Failure(message: "Handle permission denied error");
          break;
        case 'not-found':
          failure = Failure(message: "Handle document not found error");
          break;
        default:
          failure = Failure(message: "An unknown error occured");
          break;
      }
    }
    return Stream.value([]);
  }

}
