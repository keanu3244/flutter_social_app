import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_social_app/utils/file_utils.dart';
import 'package:my_social_app/utils/firebase.dart';
import 'package:uuid/uuid.dart';

abstract class Service {
  // 模拟上传图片，参数改为 String 类型
  Future<String> uploadImage(String ref, File file) async {
    String ext = FileUtils.getFileExtension(file);
    String fileUrl = 'https://fake-image-url.com/${Uuid().v4()}.$ext';
    return fileUrl;
  }
}
