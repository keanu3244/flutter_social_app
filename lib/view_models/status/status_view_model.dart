import 'dart:io';
import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_social_app/models/message.dart';
import 'package:my_social_app/models/status.dart';
import 'package:my_social_app/models/story_model.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/posts/story/confrim_status.dart';
import 'package:my_social_app/services/post_service.dart';
import 'package:my_social_app/services/status_services.dart';
import 'package:my_social_app/services/user_service.dart';
import 'package:my_social_app/utils/constants.dart';
import 'package:my_social_app/utils/firebase.dart';

class StatusViewModel extends ChangeNotifier {
  //Services
  UserService userService = UserService();
  PostService postService = PostService();
  StatusService statusService = StatusService();

  //Keys
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Variables
  bool loading = false;
  String? username;
  File? mediaUrl;
  final picker = ImagePicker();
  String? description;
  String? email;
  String? userDp;
  String? userId;
  String? imgLink;
  bool edit = false;
  String? id;

  //integers
  int pageIndex = 0;

  setDescription(String val) {
    print('SetDescription $val');
    description = val;
    notifyListeners();
  }

  final mockUsers = {
    'userId': 'user1',
    'photoUrl': 'https://example.com/user1.jpg',
    'username': 'User 1',
    'status': 'Test status',
    // 其他你需要的字段
  };

  List<Map<String, dynamic>> mockStatuses = [
    {
      'userId': 'user1',
      'status': 'Test status',
      // 其他你需要的字段
    },
    {'userId': 'user2', 'status': 'Another status'},
  ];

  //Functions
  //Functions
  pickImage({bool camera = false, BuildContext? context}) async {
    loading = true;
    notifyListeners();
    try {
      XFile? pickedFile = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Constants.lightAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(minimumAspectRatio: 1.0),
        ],
      );
      mediaUrl = File(croppedFile!.path);
      loading = false;
      Navigator.of(
        context!,
      ).push(CupertinoPageRoute(builder: (_) => ConfirmStatus()));
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Cancelled', context);
    }
  }

  //send message
  sendStatus(String chatId, StatusModel message) {
    statusService.sendStatus(message, chatId);
  }

  //send the first message
  Future<String> sendFirstStatus(StatusModel message) async {
    String newChatId = await statusService.sendFirstStatus(message);

    return newChatId;
  }

  resetPost() {
    mediaUrl = null;
    description = null;
    edit = false;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
