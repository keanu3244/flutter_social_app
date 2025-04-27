import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_social_app/models/status.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/posts/story/status_view.dart';
import 'package:my_social_app/widgets/indicators.dart';

class StoryWidget extends StatelessWidget {
  StoryWidget({super.key});

  // 当前用户 ID
  String currentUserId() => 'user1';

  // 模拟用户数据
  final List<Map<String, dynamic>> mockUsers = [
    {
      'id': 'user1',
      'username': 'demo1',
      'email': 'user1@example.com',
      'photoUrl': 'https://img.qianshengclub.com/MTc0MjE4MzAwMzUyNyM3MDcjcG5n.png',
      'bio': '热爱生活',
      'country': '中国',
    },
    {
      'id': 'user2',
      'username': 'demo2',
      'email': 'user2@example.com',
      'photoUrl': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'bio': '探索世界',
      'country': '加拿大',
    },
  ];

  // 模拟状态数据
  List<Map<String, dynamic>> mockStatuses = [
    {
      'chatId': 'chat1',
      'userId': 'user1',
      'statusId': 'status1',
      'whoCanSee': ['user1', 'user2'],
      'status': {
        'statusId': 'status1',
        'url': 'https://fake-status1.jpg',
        'type': 'image',
        'timestamp': DateTime.now().subtract(Duration(hours: 1)),
        'ownerId': 'user1',
      },
    },
    {
      'chatId': 'chat2',
      'userId': 'user2',
      'statusId': 'status2',
      'whoCanSee': ['user1', 'user2'],
      'status': {
        'statusId': 'status2',
        'url': 'https://fake-status2.jpg',
        'type': 'image',
        'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
        'ownerId': 'user2',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: Stream.value(
            mockStatuses
                .where(
                  (status) =>
                      (status['whoCanSee'] as List).contains(currentUserId()),
                )
                .toList(),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> chatList = snapshot.data!;
              if (chatList.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  itemCount: chatList.length,
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> statusList = chatList[index];
                    StatusModel status = StatusModel.fromJson(
                      statusList['status'],
                    );
                    List users = statusList['whoCanSee'] as List;
                    users.remove(currentUserId());
                    return _buildStatusAvatar(
                      context, // 传递 context
                      statusList['userId'] as String,
                      statusList['chatId'] as String,
                      status.statusId!,
                      index,
                    );
                  },
                );
              } else {
                return Center(child: Text('No Status'));
              }
            } else {
              return circularProgress(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusAvatar(
    BuildContext context, // 添加 context 参数
    String userId,
    String chatId,
    String messageId,
    int index,
  ) {
    // 从 mockUsers 获取用户信息
    Map<String, dynamic>? userData = mockUsers.firstWhere(
      (user) => user['id'] == userId,
      orElse: () => {},
    );
    if (userData.isEmpty) {
      return const SizedBox();
    }
    UserModel user = UserModel.fromJson(userData);

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => StatusScreen(
              //       statusId: chatId,
              //       storyId: messageId,
              //       initPage: index,
              //       userId: userId,
              //     ),
              //   ),
              // );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary, // 使用传递的 context
                shape: BoxShape.circle,
                border: Border.all(color: Colors.transparent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: Offset(0.0, 0.0),
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: CircleAvatar(
                  radius: 35.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
                ),
              ),
            ),
          ),
          Text(
            user.username!,
            style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
