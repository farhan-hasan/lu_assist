import '../../../auth/data/model/user_model.dart';

class NewsFeedGeneric {
  bool isLoading;

  NewsFeedGeneric({this.isLoading = false});

  NewsFeedGeneric update({bool? isLoading}) {
    return NewsFeedGeneric(
        isLoading: isLoading ?? this.isLoading,);
  }
}
