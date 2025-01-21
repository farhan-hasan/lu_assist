import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lu_assist/src/core/global/global_variables.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/core/utils/logger/logger.dart';
import 'package:lu_assist/src/features/news_feed/data/model/feed_model.dart';
import 'package:lu_assist/src/features/news_feed/presentation/view_model/news_feed_controller.dart';

import '../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../core/styles/theme/app_theme.dart';
import '../../../../core/utils/constants/enum.dart';
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../auth/data/model/user_model.dart';
import '../../../profile/presentation/view_model/profile_controller.dart';
import 'components/post_card.dart';
import 'package:lu_assist/src/features/profile/presentation/view_model/profile_generic.dart';

class NewsFeedScreen extends ConsumerStatefulWidget {
  const NewsFeedScreen({super.key});

  static const route = '/news_feed_screen';

  static setRoute() => '/news_feed_screen';

  @override
  ConsumerState<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends ConsumerState<NewsFeedScreen> {
  final SharedPreferenceManager sharedPreferenceManager =
      sl.get<SharedPreferenceManager>();
  final TextEditingController feedController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      initData();
    });
    super.initState();
  }

  initData() async {
    UserModel? userModel = await ref.read(profileProvider.notifier).readProfile(
        sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_UID));
  }

  @override
  Widget build(BuildContext context) {
    final profileController = ref.watch(profileProvider);
    final newsFeedController = ref.watch(newsFeedProvider);
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF433878),
          title: Image.asset(
            'assets/images/LU_Assist__LOGO.png',
            height: screenSize.height * 0.20,
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              // Input Section
              if(profileController.userModel?.role == Role.admin.name)
                addPostSection(profileController),
              const SizedBox(height: 10),

              Expanded(
                  child: FutureBuilder<Stream<List<FeedModel>>>(
                      future: ref.read(newsFeedProvider.notifier).getAllPosts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return StreamBuilder<List<FeedModel>>(
                              stream: snapshot.data,
                              builder: (context, feedShot) {
                                if (feedShot.hasData) {
                                  List<FeedModel> feedList =
                                      feedShot.data ?? [];
                                  final dateFormat =
                                      DateFormat('MMMM d, y \'at\' h:mm a');
                                  feedList.sort((a, b) {
                                    // Handle null dates
                                    if (a.createdAt == null &&
                                        b.createdAt == null) return 0;
                                    if (a.createdAt == null)
                                      return 1; // Null dates go to the end
                                    if (b.createdAt == null) return -1;
                                    return b.createdAt!.compareTo(
                                        a.createdAt!); // Newer to older
                                  });
                                  return ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: feedList.length,
                                    // Example post count
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          PostCard(
                                            feedId: feedList[index].id ?? "",
                                            author: feedList[index].name ?? "",
                                            time: feedList[index].createdAt !=
                                                    null
                                                ? dateFormat.format(
                                                    feedList[index].createdAt!)
                                                : "",
                                            content: feedList[index].post ?? "",
                                            profileImage:
                                                feedList[index].image ??
                                                    dummyUserImage,
                                          ),
                                          // Space between posts
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                      child: Text('No posts found'));
                                }
                              });
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          ));
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }

  Container addPostSection(ProfileGeneric profileController) {
    return Container(
              color: const Color(0xFF433878),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    child: ClipOval(
                        child: profileController.isProfilePictureLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                imageUrl:
                                    profileController.userModel?.image ??
                                        dummyUserImage,
                                // placeholder: (context, url) =>
                                //     CircularProgressIndicator(color: Colors.white,),
                              )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  300, // Maximum width for the TextField
                            ),
                            child: TextFormField(
                              cursorColor: primaryColor,
                              controller: feedController,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Add post',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                  // Border color when selected
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  //borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              maxLines: 3,
                              minLines: 1,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      debug(ref.read(profileProvider).userModel?.toJson());
                      String post = feedController.text;
                      ref.read(newsFeedProvider.notifier).addPost(post: post);
                      feedController.clear();
                      WidgetsBinding.instance.focusManager.primaryFocus
                          ?.unfocus();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.send, color: Color(0xFF4C3575)),
                    ),
                  ),
                ],
              ),
            );
  }

  @override
  void dispose() {
    feedController.dispose();
    super.dispose();
  }
}
