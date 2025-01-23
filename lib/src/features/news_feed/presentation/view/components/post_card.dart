import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/core/database/local/shared_preference/shared_preference_manager.dart';
import 'package:lu_assist/src/core/utils/constants/enum.dart';
import 'package:lu_assist/src/features/news_feed/presentation/view_model/news_feed_controller.dart';
import 'package:lu_assist/src/shared/dependency_injection/dependency_injection.dart';

import '../../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../../core/styles/theme/app_theme.dart';
import '../../../../profile/presentation/view_model/profile_controller.dart';

class PostCard extends ConsumerStatefulWidget {
  final String author;
  final String time;
  final String content;
  final String profileImage;
  final String feedId;

  const PostCard({
    Key? key,
    required this.author,
    required this.time,
    required this.content,
    required this.profileImage,
    required this.feedId,
  }) : super(key: key);

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  ValueNotifier<bool> isEditingListener = ValueNotifier(false);
  final TextEditingController editFeedController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  SharedPreferenceManager sharedPreferenceManager = sl.get<SharedPreferenceManager>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = ref.watch(profileProvider);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
            valueListenable: isEditingListener,
            builder: (context, isEditing, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor,
                        child: ClipOval(
                            child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 120,
                          width: 120,
                          imageUrl: widget.profileImage,
                          // placeholder: (context, url) =>
                          //     CircularProgressIndicator(color: Colors.white,),
                        )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.time,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_ROLE) == Role.admin.name)
                        PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            isEditingListener.value = true;
                            editFeedController.text = widget.content;
                          } else if (value == 'delete') {
                            deletePost(context);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text('Edit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text('Delete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  isEditing
                      ? SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  cursorColor: primaryColor,
                                  controller: editFeedController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Edit post',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                      // Border color when selected
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      //borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                  ),
                                  maxLines: 3,
                                  minLines: 1,
                                ),
                              ),
                              SizedBox(width: 8,),
                              InkWell(
                                onTap: () {
                                  String post = editFeedController.text;
                                  ref.read(newsFeedProvider.notifier).editPost(feedId:widget.feedId,post: post);
                                  isEditingListener.value = false;
                                  editFeedController.clear();
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 20,
                                  child: Icon(Icons.check,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        )
                      : Text(
                          widget.content,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ],
              );
            }),
      ),
    );
  }

  void deletePost(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.question_mark,
                  color: primaryColor,
                  size: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Are you sure you want to delete the post?",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Yes',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: primaryColor),
              ),
              onPressed: () async {
                ref
                    .read(newsFeedProvider.notifier)
                    .deletePost(feedId: widget.feedId);
                context.pop();
              },
            ),
            TextButton(
              child: Text(
                'No',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: primaryColor),
              ),
              onPressed: () async {
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
