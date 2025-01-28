import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lu_assist/src/core/global/global_variables.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/features/bus_list/presentation/view/bus_list_screen.dart';
import 'package:lu_assist/src/features/news_feed/data/model/feed_model.dart';
import 'package:lu_assist/src/features/news_feed/presentation/view_model/news_feed_controller.dart';
import 'package:lu_assist/src/features/profile/presentation/view_model/profile_generic.dart';

import '../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../core/notification/push_notification/push_notification_handler.dart';
import '../../../../core/styles/theme/app_theme.dart';
import '../../../../core/utils/constants/enum.dart';
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../auth/data/model/user_model.dart';
import '../../../profile/presentation/view_model/profile_controller.dart';
import 'components/post_card.dart';

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
  UserModel? userModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      await FirebaseMessaging.instance.subscribeToTopic('new_post');
      await FirebaseMessaging.instance.subscribeToTopic('bus_request_approval');
      if(sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_ROLE) == Role.admin.name) {
        await FirebaseMessaging.instance.subscribeToTopic('bus_request');
      }
      initData();
    });
    PushNotificationHandler.setupInteractedMessage();
    super.initState();
  }

  initData() async {
    userModel = await ref.read(profileProvider.notifier).readProfile(
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
        if (feedController.text == "") {
          formKey.currentState!.reset();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("News Feed"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                          child: profileController.isProfilePictureLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: 120,
                                  imageUrl: (profileController
                                                  .userModel?.image ??
                                              dummyUserImage) ==
                                          ""
                                      ? dummyUserImage
                                      : profileController.userModel?.image ??
                                          dummyUserImage,
                                  // placeholder: (context, url) =>
                                  //     CircularProgressIndicator(color: Colors.white,),
                                )),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome, ${profileController.userModel?.name ?? ""}!',
                      style: context.titleMedium?.copyWith(color: Colors.white),
                    ),
                    Text(
                      profileController.userModel?.email ?? "",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (userModel?.role == Role.admin.name)
                ListTile(
                  leading: const Icon(
                    Icons.directions_bus_filled,
                    color: primaryColor,
                  ),
                  title: const Text('Bus list'),
                  onTap: () {
                    context.push(BusListScreen.route);
                  },
                ),
              const Divider(), // Separator
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged Out!')),
                  );
                },
              ),
            ],
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Input Section
                if (sharedPreferenceManager.getValue(
                        key: SharedPreferenceKeys.USER_ROLE) ==
                    Role.admin.name)
                  addPostSection(profileController),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: FutureBuilder<Stream<List<FeedModel>>>(
                        future:
                            ref.read(newsFeedProvider.notifier).getAllPosts(),
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
                                      itemCount: feedList.length,
                                      // Example post count
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            PostCard(
                                              feedId: feedList[index].id ?? "",
                                              author:
                                                  feedList[index].name ?? "",
                                              time: feedList[index].createdAt !=
                                                      null
                                                  ? dateFormat.format(
                                                      feedList[index]
                                                          .createdAt!)
                                                  : "",
                                              content:
                                                  feedList[index].post ?? "",
                                              profileImage:
                                                  feedList[index].image ??
                                                      dummyUserImage,
                                              userId:
                                                  feedList[index].userId ?? "",
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
      ),
    );
  }

  Widget addPostSection(ProfileGeneric profileController) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: ClipOval(
              child: profileController.isProfilePictureLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 120,
                      width: 120,
                      imageUrl: (profileController.userModel?.image ??
                                  dummyUserImage) ==
                              ""
                          ? dummyUserImage
                          : profileController.userModel?.image ??
                              dummyUserImage,
                      // placeholder: (context, url) =>
                      //     CircularProgressIndicator(color: Colors.white,),
                    )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This field cannot be empty";
              }
              return null; // Field is valid
            },
            cursorColor: primaryColor,
            controller: feedController,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Add post',
            ),
            maxLines: 3,
            minLines: 1,
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            if (feedController.text == "") {
              BotToast.showText(text: "Please add content");
              feedController.clear();
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              return;
            }

            String post = feedController.text;
            ref.read(newsFeedProvider.notifier).addPost(post: post);
          },
          child: const CircleAvatar(
            backgroundColor: primaryColor,
            radius: 20,
            child: Icon(Icons.send),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    feedController.dispose();
    super.dispose();
  }
}
