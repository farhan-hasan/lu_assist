import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

import '../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../auth/data/model/user_model.dart';
import '../../../profile/presentation/view_model/profile_controller.dart';

class NewsFeedScreen extends ConsumerStatefulWidget {
  const NewsFeedScreen({super.key});
  static const route = '/news_feed_screen';

  static setRoute() => '/news_feed_screen';

  @override
  ConsumerState<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends ConsumerState<NewsFeedScreen> {
  final SharedPreferenceManager sharedPreferenceManager = sl.get<SharedPreferenceManager>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      initData();
    });
    super.initState();
  }

  initData() async {
    UserModel? userModel = await ref.read(profileProvider.notifier).readProfile(sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_UID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF433878),
        title: Image.asset(
          'images/lu_assist_logo.png',
          height: 50,
        ),
      ),
      body: Column(
        children: [
          // Divider
          Divider(height: 1, color: Colors.grey[300]),

          // Input Section
          Container(
            color: const Color(0xFF433878),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/256/1077/1077012.png',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 300, // Maximum width for the TextField
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Write something...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            maxLines: null,
                            minLines: 1,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.add, color: const Color(0xFF4C3575)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Posts Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 7, // Example post count
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    PostCard(
                      author: 'Syed Farhan Hasan',
                      time: '${index + 1}h ago',
                      content: index == 0
                          ? 'No More Buses For Tomorrow.'
                          : 'On Saturday the bus will start at 8:am for exams scheduled in the morning and 12:15 pm for exams scheduled in the evening from all start points of all routes.',
                      profileImage: 'https://via.placeholder.com/150',
                    ),
                    if (index != 6) const SizedBox(height: 10), // Space between posts
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String author;
  final String time;
  final String content;
  final String profileImage;

  const PostCard({
    Key? key,
    required this.author,
    required this.time,
    required this.content,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(profileImage),
              onBackgroundImageError: (_, __) => const Icon(Icons.error),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
