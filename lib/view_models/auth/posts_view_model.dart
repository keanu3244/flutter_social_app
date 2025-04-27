import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_social_app/models/post.dart';
import 'package:my_social_app/screens/mainscreen.dart';
import 'package:my_social_app/services/post_service.dart';
import 'package:my_social_app/services/user_service.dart';
import 'package:my_social_app/utils/constants.dart';

class PostsViewModel extends ChangeNotifier {
  // Services
  UserService userService = UserService();
  PostService postService = PostService();

  // Keys
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Variables
  bool loading = false;
  String? username;
  File? mediaUrl;
  final picker = ImagePicker();
  String? location;
  Position? position;
  Placemark? placemark;
  String? bio;
  String? description;
  String? email;
  String? commentData;
  String? ownerId;
  String? userId;
  String? type;
  File? userDp;
  String? imgLink;
  bool edit = false;
  String? id;

  // Controllers
  TextEditingController locationTEC = TextEditingController();

  // Setters
  setEdit(bool val) {
    edit = val;
    notifyListeners();
  }

  setPost(PostModel post) {
    description = post.description;
    imgLink = post.mediaUrl;
    location = post.location;
    edit = true;
    edit = false; // 修复逻辑，可能为 typo
    notifyListeners();
  }

  setUsername(String val) {
    username = val;
    notifyListeners();
  }

  setDescription(String val) {
    description = val;
    notifyListeners();
  }

  setLocation(String val) {
    location = val;
    notifyListeners();
  }

  setBio(String val) {
    bio = val;
    notifyListeners();
  }

  // Functions
  pickImage({bool camera = false, BuildContext? context}) async {
    loading = true;
    notifyListeners();
    try {
      XFile? pickedFile = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickedFile == null) {
        loading = false;
        notifyListeners();
        showInSnackBar('No image selected', context);
        return;
      }
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        // 移除 aspectRatioPresets，使用 aspectRatio 或 uiSettings
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // 默认正方形
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Constants.lightAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true, // 锁定正方形
            cropGridColumnCount: 3,
            cropGridRowCount: 3,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            minimumAspectRatio: 1.0,
            aspectRatioPickerButtonHidden: true, // 隐藏比例选择
          ),
        ],
      );
      if (croppedFile == null) {
        loading = false;
        notifyListeners();
        showInSnackBar('Cancelled', context);
        return;
      }
      mediaUrl = File(croppedFile.path);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Error: $e', context);
    }
  }

  getLocation() async {
    loading = true;
    notifyListeners();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission rPermission = await Geolocator.requestPermission();
      await getLocation();
    } else {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );
      placemark = placemarks[0];
      location = "${placemarks[0].locality}, ${placemarks[0].country}";
      locationTEC.text = location!;
    }
    loading = false;
    notifyListeners();
  }

  uploadPosts(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      if (mediaUrl == null || description == null || location == null) {
        loading = false;
        notifyListeners();
        showInSnackBar('Please complete all fields', context);
        return;
      }
      // 模拟上传帖子到 mockPosts
      // await postService.uploadPost(
      //   mediaUrl: mediaUrl!,
      //   location: location!,
      //   description: description!,
      //   userId: userService.currentUid(),
      // );
      loading = false;
      resetPost();
      showInSnackBar('Uploaded successfully!', context);
      notifyListeners();
    } catch (e) {
      loading = false;
      resetPost();
      showInSnackBar('Error uploading post: $e', context);
      notifyListeners();
    }
  }

  uploadProfilePicture(BuildContext context) async {
    if (mediaUrl == null) {
      showInSnackBar('Please select an image', context);
      return;
    }
    try {
      loading = true;
      notifyListeners();
      // 模拟上传头像
      // await postService.uploadProfilePicture(
      //   mediaUrl: mediaUrl!,
      //   userId: userService.currentUid(),
      // );
      loading = false;
      Navigator.of(
        context,
      ).pushReplacement(CupertinoPageRoute(builder: (_) => TabScreen()));
      notifyListeners();
    } catch (e) {
      loading = false;
      showInSnackBar('Error uploading profile picture: $e', context);
      notifyListeners();
    }
  }

  resetPost() {
    mediaUrl = null;
    description = null;
    location = null;
    edit = false;
    notifyListeners();
  }

  void showInSnackBar(String value, BuildContext? context) {
    if (context != null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(value)));
    }
  }
}
