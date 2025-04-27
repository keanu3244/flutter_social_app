import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:my_social_app/models/post.dart';
import 'package:my_social_app/widgets/indicators.dart';
import 'package:my_social_app/widgets/userpost.dart';

class ListPosts extends StatefulWidget {
  final String userId;
  final String username;

  const ListPosts({super.key, required this.userId, required this.username});

  @override
  State<ListPosts> createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  // 模拟帖子数据
  final List<Map<String, dynamic>> mockPosts = [
    {
      'id': 'post1',
      'userId': 'user1',
      'imageUrl': 'https://fake-post1.jpg',
      'caption': 'Beautiful day!',
      'location': 'United States',
      'timestamp': DateTime.now().subtract(Duration(days: 1)),
      'likes': 10,
      'comments': 2,
      'ownerId': 'user1',
      'postId': 'post1',
      'description': 'Enjoying the sunshine',
      'mediaUrl': 'https://fake-post1.jpg',
    },
    {
      'id': 'post2',
      'userId': 'user2',
      'imageUrl': 'https://fake-post2.jpg',
      'caption': 'Travel vibes',
      'location': 'Canada',
      'timestamp': DateTime.now().subtract(Duration(hours: 5)),
      'likes': 15,
      'comments': 3,
      'ownerId': 'user2',
      'postId': 'post2',
      'description': 'Exploring new places',
      'mediaUrl': 'https://fake-post2.jpg',
    },
    {
      'id': 'post3',
      'userId': 'user1',
      'imageUrl': 'https://fake-post3.jpg',
      'caption': 'Chasing dreams',
      'location': 'China',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
      'likes': 8,
      'comments': 1,
      'ownerId': 'user1',
      'postId': 'post3',
      'description': 'Never stop dreaming',
      'mediaUrl': 'https://fake-post3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Ionicons.chevron_back),
        ),
        title: Column(
          children: [
            Text(
              widget.username.toUpperCase(),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Text(
              'Posts',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: Future.value(
            mockPosts.where((post) => post['ownerId'] == widget.userId).toList()
              ..sort(
                (a, b) => (b['timestamp'] as DateTime).compareTo(
                  a['timestamp'] as DateTime,
                ),
              ),
          ),
          builder: (
            context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.hasData) {
              var posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  PostModel post = PostModel.fromJson(posts[index]);
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: UserPost(post: post),
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress(context);
            } else {
              return Center(
                child: Text(
                  'No Feeds',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
