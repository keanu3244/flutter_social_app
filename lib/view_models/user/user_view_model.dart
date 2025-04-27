import 'package:flutter/material.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? user;
  final UserService userService = UserService();

  void setUser() {
    user = userService.getUser(userService.currentUid());
    notifyListeners();
  }
}
