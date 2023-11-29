import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:generadorreportes/core/utils/code_uitils.dart';
import 'package:generadorreportes/core/utils/ui_utils.dart';
import 'package:generadorreportes/features/login/display/screens/register_screen.dart';
import 'package:generadorreportes/widgets/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';
import '../providers/login_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoadedScreen = false;
  late LoginProvider loginProvider;
  UiUtils uiUtils = UiUtils();

  @override
  void didChangeDependencies() {
    if (!isLoadedScreen) {
      isLoadedScreen = true;
      loginProvider = Provider.of<LoginProvider>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicia Sesión'),
        backgroundColor: Colors.green, // Color naranja
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginProvider.emailController,
              decoration: InputDecoration(
                labelText: 'Correo',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: loginProvider.passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? userJson = prefs.getString('user');

                if (userJson != null) {
                  Map<String, dynamic> userMap = jsonDecode(userJson);
                  UserModel storedUser = UserModel.fromJson(userMap);

                  if (loginProvider.emailController.text == storedUser.email &&
                      loginProvider.passwordController.text ==
                          storedUser.password) {
                    log('Login successful! Welcome, ${storedUser.name}');
                    await loginProvider.getUserData();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainScreen()));
                  } else {
                    // ignore: use_build_context_synchronously
                    uiUtils.showFlushBar(
                      context: context,
                      title: 'Error al iniciar',
                      message: 'Verifica tus credenciales',
                      icon: Icons.error,
                    );
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  uiUtils.showFlushBar(
                    context: context,
                    title: 'Error al iniciar',
                    message: 'Usuario no encontrado',
                    icon: Icons.error,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Color verde
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Iniciar',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange, // Color naranja
              ),
              child: const Text(
                'Crea una cuenta',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
