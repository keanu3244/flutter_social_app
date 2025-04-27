// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:my_social_app/utils/firebase.dart';

class AuthService {
  // 模拟当前用户
  Map<String, dynamic>? _currentUser;

  // 模拟用户数据
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 'user1',
      'username': 'demo1',
      'email': 'demo1@test.com',
      'country': 'USA',
    },
    {
      'id': 'user2',
      'username': 'demo2',
      'email': 'demo2@test.com',
      'country': 'UK',
    },
  ];

  // 获取当前用户
  Map<String, dynamic>? getCurrentUser() => _currentUser;

  // 创建用户
  Future<bool> createUser({
    String? name,
    String? email,
    String? country,
    String? password,
  }) async {
    if (_mockUsers.any((user) => user['email'] == email)) {
      throw 'email-already-in-use';
    }
    var newUser = {
      'id': 'user${_mockUsers.length + 1}',
      'username': name,
      'email': email,
      'country': country,
    };
    _mockUsers.add(newUser);
    _currentUser = newUser;
    return true;
  }

  // 模拟保存到 Firestore
  Future<void> saveUserToFirestore(
    String name,
    Map<String, dynamic> user,
    String email,
    String country,
  ) async {
    // 已在上一步保存，无需操作
  }

  // 登录
  Future<bool> loginUser({String? email, String? password}) async {
    var user = _mockUsers.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );
    if (user.isNotEmpty) {
      _currentUser = user;
      return true;
    }
    throw 'user-not-found';
  }

  // 忘记密码
  Future<void> forgotPassword(String email) async {
    if (!_mockUsers.any((user) => user['email'] == email)) {
      throw 'user-not-found';
    }
    print('Password reset sent to $email');
  }

  // 登出
  Future<void> logOut() async {
    _currentUser = null;
  }

  // 错误处理
  String handleFirebaseAuthError(String e) {
    if (e.contains('email-already-in-use')) return 'Email already in use.';
    if (e.contains('user-not-found') || e.contains('wrong-password'))
      return 'Invalid credentials.';
    return e;
  }
}
