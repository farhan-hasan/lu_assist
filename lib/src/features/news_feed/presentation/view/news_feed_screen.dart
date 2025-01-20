import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});
  static const route = '/news_feed_screen';

  static setRoute() => '/news_feed_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF433878),
        title: Image.asset(
          'images/lu_assist_logo.png',
          height: 50,

        ),

      ),
      body: Column(
        children: [
          // Input Section
          Column(
            children: [
              Container(
                color: Colors.white,
                height: 1,
              )
            ],
          ),
          Column(
            children: [
              Container(
                color: Color(0xFF433878),
                height: 32,
              )
            ],
          ),
          Container(
            color: Color(0xFF433878), // Purple background
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/256/1077/1077012.png'), // Placeholder image
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.add, color: Color(0xFF4C3575)),
                ),
              ],
            ),
          ),
          SizedBox(height: 10), // Space between input row and post list
          // Posts Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                PostCard(
                  author: 'Syed Farhan Hasan',
                  time: '1h ago',
                  content: 'No More Buses For Tomorrow.',
                  profileImage:
                  'https://via.placeholder.com/150', // Placeholder image
                ),
                SizedBox(height: 10),
                PostCard(
                  author: 'Syed Farhan Hasan',
                  time: '2h ago',
                  content:
                  'On Saturday the bus will start at 8:am for exam scheduled in the morning and 12:15pm for the exam scheduled in evening from all start points of all routes.',
                  profileImage:
                  'https://via.placeholder.com/150', // Placeholder image
                ),
                SizedBox(height: 10),
                PostCard(
                  author: 'Syed Farhan Hasan',
                  time: '2h ago',
                  content:
                  'On Saturday the bus will start at 8:am for exam scheduled in the morning and 12:15pm for the exam scheduled in evening from all start points of all routes.',
                  profileImage:
                  'https://via.placeholder.com/150', // Placeholder image
                ),
                SizedBox(height: 10),
                PostCard(
                  author: 'Syed Farhan Hasan',
                  time: '2h ago',
                  content:
                  'On Saturday the bus will start at 8:am for exam scheduled in the morning and 12:15pm for the exam scheduled in evening from all start points of all routes.',
                  profileImage:
                  'https://via.placeholder.com/150', // Placeholder image
                ),
                SizedBox(height: 10),
                PostCard(
                  author: 'Syed Farhan Hasan',
                  time: '2h ago',
                  content:
                  'On Saturday the bus will start at 8:am for exam scheduled in the morning and 12:15pm for the exam scheduled in evening from all start points of all routes.',
                  profileImage:
                  'https://via.placeholder.com/150', // Placeholder image
                ),
                SizedBox(height: 10),
                PostCard(
                  author: 'Syed Farhan Hasan',
                  time: '2h ago',
                  content:
                  'On Saturday the bus will start at 8:am for exam scheduled in the morning and 12:15pm for the exam scheduled in evening from all start points of all routes.',
                  profileImage:
                  'https://via.placeholder.com/150', // Placeholder image
                ),SizedBox(height: 10),
                PostCard(
                  author: 'Syed Farhan Hasan',
                  time: '2h ago',
                  content:
                  'On Saturday the bus will start at 8:am for exam scheduled in the morning and 12:15pm for the exam scheduled in evening from all start points of all routes.',
                  profileImage:
                  'https://via.placeholder.com/150', // Placeholder image
                ),


              ],
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
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(fontSize: 14),
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
