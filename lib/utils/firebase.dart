import 'package:uuid/uuid.dart';

// 模拟 Firebase 实例和引用
final Uuid uuid = Uuid();

// 模拟的集合数据（代替 Firestore 集合）
final Map<String, List<Map<String, dynamic>>> mockCollections = {
  'users': [],
  'chats': [],
  'posts': [],
  'comments': [],
  'notifications': [],
  'followers': [],
  'following': [],
  'likes': [],
  'favoriteUsers': [],
  'chatIds': [],
  'status': [],
};

// 模拟的存储引用（代替 Storage 路径）
final Map<String, String> mockStorageRefs = {
  'profilePic': 'https://fake-image-url.com/profilePic/',
  'posts': 'https://fake-image-url.com/posts/',
  'status': 'https://fake-image-url.com/status/',
};
