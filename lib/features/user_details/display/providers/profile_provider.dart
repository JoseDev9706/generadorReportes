import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:generadorreportes/features/login/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/code_uitils.dart';
import '../../../login/display/providers/login_provider.dart';

class ProfileProvider with ChangeNotifier {
  bool _isEditingProfile = false;
  final LoginProvider loginProvider;

  ProfileProvider(this.loginProvider);

  bool get isEditingProfile => _isEditingProfile;

  void startEditing() {
    _isEditingProfile = true;
    notifyListeners();
  }

  void cancelEditing() {
    _isEditingProfile = false;
    notifyListeners();
  }

  void saveChanges(UserModel newUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginProvider.updateUser(newUser);
    String userJson = jsonEncode(newUser.toJson());
    prefs.setString('user', userJson);

    cancelEditing();
    notifyListeners();
  }

  Future<File?> uploadPhoto({
    required bool fromCamera,
    required BuildContext context,
  }) async {
    try {
      CodeUtils codeUtils = CodeUtils();
      // Verifica los permisos antes de abrir la cámara
      Map<String, dynamic> response = await codeUtils.checkStoragePermissions();
      log('Permisos solicitados: $response');
      if (!response['granted']) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Permisos requeridos'),
              content: Text(response['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return null;
      }

      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile == null) {
        return null;
      }

      File finalFile = File(pickedFile.path);
      notifyListeners();

      return finalFile;
    } catch (error) {
      log('Error al abrir la cámara: $error');
      return null;
    }
  }
}
