import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
class AuthService {
  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
  Future<void> changePassword({required String email, required String oldPassword, required String newPassword}) async {
    try {
      // Xác thực lại người dùng với mật khẩu cũ
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);

      // Nếu xác thực thành công, cập nhật mật khẩu mới cho người dùng
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
      print("Success");
    } catch (error) {
      // Xử lý các lỗi xác thực hoặc cập nhật mật khẩu
      print("Lỗi thay đổi mật khẩu: $error");
    }
  }
  hideKeyBoard() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }
   pickImage(ImageSource source) async{
    final ImagePicker _imagePicker=ImagePicker();
    XFile? _file=await _imagePicker.pickImage(source: source);
    if(_file!=null){
      return await _file.readAsBytes();
    }
    print("No selected Image");
  }
}
