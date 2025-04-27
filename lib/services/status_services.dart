import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_social_app/models/status.dart';
import 'package:my_social_app/services/user_service.dart';
import 'package:uuid/uuid.dart';

class StatusService {
  String statusId = const Uuid().v1();
  UserService userService = UserService();

  // 模拟的存储：状态数据
  final Map<String, Map<String, List<Map<String, dynamic>>>> _mockStatuses = {};
  final Map<String, Map<String, dynamic>> _mockChatMetadata = {};

  // 模拟当前用户 ID
  String get _currentUserId =>
      'user1'; // 可替换为 AuthService.getCurrentUser()['id']

  // 模拟用户 ID 列表
  final List<String> _mockUserIds = ['user1', 'user2', 'user3'];

  void showSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  // 发送状态
  Future<void> sendStatus(StatusModel status, String chatId) async {
    _mockStatuses[chatId] ??= {'statuses': []};
    _mockStatuses[chatId]!['statuses']!.add(status.toJson());
    _mockChatMetadata[chatId] = {'userId': _currentUserId};
  }

  // 发送首次状态
  Future<String> sendFirstStatus(StatusModel status) async {
    String chatId = Uuid().v4();
    _mockChatMetadata[chatId] = {'whoCanSee': _mockUserIds};
    await sendStatus(status, chatId);
    return chatId;
  }

  // 模拟上传图片
  Future<String> uploadImage(File image) async {
    return 'https://fake-image-url.com/${Uuid().v4()}.jpg';
  }
}
