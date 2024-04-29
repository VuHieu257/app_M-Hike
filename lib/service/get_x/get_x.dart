import 'dart:typed_data';

import 'package:get/get.dart';

class UserDataController extends GetxController {
  var displayName = ''.obs;
  var password = ''.obs;
  var email = ''.obs;

  void updateUserData(String newDisplayName, String newPassword,String newEmail) {
    displayName.value = newDisplayName;
    password.value = newPassword;
    email.value = newEmail;
  }

  Uint8List? _img;

// Hàm để lấy dữ liệu hình ảnh
  Uint8List? getX() {
    return _img;
  }

// Hàm để thiết lập dữ liệu hình ảnh
  void setX(Uint8List img) {
    _img = img;
  }
}
