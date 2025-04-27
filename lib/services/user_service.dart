import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/services/services.dart';

class UserService extends Service with ChangeNotifier {
  final Map<String, Map<String, dynamic>> _mockUsers = {
    'user1': {
      'id': 'user1',
      'username': 'demo1',
      'bio': '',
      'country': 'USA',
      'photoUrl': 'https://img.qianshengclub.com/MTc0MjE4MzAwMzUyNyM3MDcjcG5n.png',
      'isOnline': true,
      'lastSeen': DateTime.now(),
      'email': 'user1@example.com',
    },
    'user2': {
      'id': 'user2',
      'username': 'demo2',
      'bio': '',
      'country': 'Canada',
      'photoUrl': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'isOnline': false,
      'lastSeen': DateTime.now(),
      'email': 'user2@example.com',
    },
  };

  String currentUid() => 'user1';

  Future<void> setUserStatus(bool isOnline) async {
    _mockUsers['user1']?['isOnline'] = isOnline;
    _mockUsers['user1']?['lastSeen'] = DateTime.now();
    notifyListeners();
  }

  Future<bool> updateProfile({
    File? image,
    String? username,
    String? bio,
    String? country,
  }) async {
    var user = _mockUsers['user1']!;
    user['username'] = username ?? user['username'];
    user['bio'] = bio ?? user['bio'];
    user['country'] = country ?? user['country'];
    if (image != null) {
      user['photoUrl'] = await uploadImage('profilePic', image);
    }
    _mockUsers['user1'] = user;
    notifyListeners();
    return true;
  }

  UserModel? getUser(String userId) {
    if (_mockUsers.containsKey(userId)) {
      return UserModel.fromJson(_mockUsers[userId]!);
    }
    return null;
  }
}
