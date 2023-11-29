import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserModel user =
      UserModel(name: '', type: '', email: '', phone: '', password: '');

  Future<void> saveUserData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    prefs.setString('user', userJson);
  }

  Future<UserModel?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      user = UserModel.fromJson(userMap);
      return user;
    } else {
      return null;
    }
  }

  void updateUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }
}
