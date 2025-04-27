import 'dart:async';
import 'package:flutter/material.dart';

class NotificationService with ChangeNotifier {
  final Map<String, List<Map<String, dynamic>>> _mockNotifications = {
    'user1': [
      {
        'id': 'notif1',
        'userId': 'user2',
        'type': 'like',
        'message': 'demo2 点赞了你的动态',
        'timestamp': DateTime.now()
            .subtract(const Duration(hours: 1))
            .millisecondsSinceEpoch,
        'postId': 'post1',
      },
      {
        'id': 'notif2',
        'userId': 'user2',
        'type': 'comment',
        'message': 'demo2 评论了你的动态',
        'timestamp': DateTime.now()
            .subtract(const Duration(hours: 2))
            .millisecondsSinceEpoch,
        'postId': 'post1',
      },
      {
        'id': 'notif3',
        'userId': 'user1',
        'type': 'follow',
        'message': 'demo1 开始关注你',
        'timestamp': DateTime.now()
            .subtract(const Duration(days: 1))
            .millisecondsSinceEpoch,
        'postId': null,
      },
    ],
  };

  Stream<List<Map<String, dynamic>>> getNotificationsStream(String userId) {
    // 模拟 Firestore 流，每秒更新一次
    return Stream.periodic(const Duration(seconds: 1), (_) {
      final notifications = _mockNotifications[userId] ?? [];
      // 按 timestamp 降序排序，限制 20 条
      final sortedNotifications = notifications
        ..sort(
            (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      return sortedNotifications.take(20).toList();
    });
  }

  void deleteAllNotifications(String userId) {
    _mockNotifications[userId]?.clear();
    notifyListeners();
  }
}
