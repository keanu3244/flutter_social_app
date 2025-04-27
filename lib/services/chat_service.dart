import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_social_app/models/message.dart';
import 'package:uuid/uuid.dart';

class ChatService with ChangeNotifier {
  final Map<String, List<Map<String, dynamic>>> _mockMessages = {};
  final Map<String, Map<String, dynamic>> _mockChats = {};
  final Uuid uuid = Uuid();
  final String _currentUserId = 'user1';

  String getCurrentUserId() => _currentUserId;

  List<Map<String, dynamic>> getMessages(String chatId) {
    return _mockMessages[chatId] ?? [];
  }

  List<Map<String, dynamic>> getUserChats(String userId) {
    final chats =
        _mockChats.entries
            .where(
              (entry) =>
                  (entry.value['users'] as List<dynamic>).contains(userId),
            )
            .map(
              (entry) => {
                'chatId': entry.key,
                'users': entry.value['users'],
                'lastTextTime': entry.value['lastTextTime'] ?? 0,
              },
            )
            .toList();
    chats.sort(
      (a, b) => (b['lastTextTime'] as int).compareTo(a['lastTextTime'] as int),
    );
    return chats;
  }

  Map<String, dynamic> getReads(String chatId) {
    return _mockChats[chatId]?['reads'] ?? {};
  }

  bool getTyping(String chatId, String userId) {
    return _mockChats[chatId]?['typing']?[userId] ?? false;
  }

  void initChat(String chatId) {
    _mockChats[chatId] ??= {'reads': {}, 'typing': {}};
    notifyListeners();
  }

  Future<void> sendMessage(Message message, String chatId) async {
    _mockMessages[chatId] ??= [];
    _mockMessages[chatId]!.add(message.toJson());
    _mockChats[chatId] ??= {};
    _mockChats[chatId]!['lastTextTime'] = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  Future<String> sendFirstMessage(Message message, String recipient) async {
    String chatId = uuid.v4();
    _mockChats[chatId] = {
      'users': [recipient, _currentUserId],
      'reads': {},
      'typing': {},
    };
    await sendMessage(message, chatId);
    notifyListeners();
    return chatId;
  }

  Future<String> uploadImage(File image, String chatId) async {
    return 'https://fake-image-url.com/$chatId/${uuid.v4()}.jpg';
  }

  Future<void> setUserRead(
    String chatId,
    Map<String, dynamic> user,
    int count,
  ) async {
    _mockChats[chatId] ??= {'reads': {}};
    _mockChats[chatId]!['reads'][user['id']] = count;
    notifyListeners();
  }

  Future<void> setUserTyping(
    String chatId,
    Map<String, dynamic> user,
    bool userTyping,
  ) async {
    _mockChats[chatId] ??= {'typing': {}};
    _mockChats[chatId]!['typing'][user['id']] = userTyping;
    notifyListeners();
  }
}
