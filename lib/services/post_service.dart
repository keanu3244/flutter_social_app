import 'package:flutter/material.dart';

class PostService with ChangeNotifier {
  final List<Map<String, dynamic>> _mockPosts = [
    {
      'id': 'post1',
      'userId': 'user1',
      'imageUrl': 'https://fake-post1.jpg',
      'caption': '这是我的第一条动态！',
      'timestamp': DateTime.now()
          .subtract(const Duration(days: 1))
          .millisecondsSinceEpoch,
      'likes': 10,
      'comments': 5,
    },
    {
      'id': 'post2',
      'userId': 'user2',
      'imageUrl': 'https://fake-post2.jpg',
      'caption': '享受美好的一天！',
      'timestamp': DateTime.now()
          .subtract(const Duration(days: 2))
          .millisecondsSinceEpoch,
      'likes': 15,
      'comments': 3,
    },
    {
      'id': 'post3',
      'userId': 'user1',
      'imageUrl': 'https://fake-post3.jpg',
      'caption': '又一个精彩时刻！',
      'timestamp': DateTime.now()
          .subtract(const Duration(days: 3))
          .millisecondsSinceEpoch,
      'likes': 20,
      'comments': 8,
    },
    // 可根据需要添加更多模拟动态
  ];

  Future<List<Map<String, dynamic>>> getPosts(int limit) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    // 按 timestamp 降序排序并限制数量
    final sortedPosts = _mockPosts
      ..sort(
          (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
    return sortedPosts.take(limit).toList();
  }
}
