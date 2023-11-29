import 'package:flutter/material.dart';
import 'package:generadorreportes/features/login/display/providers/login_provider.dart';
import 'package:provider/provider.dart';

import '../../data/models/user_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoadedScreen = false;
  late LoginProvider loginProvider;

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
        title: const Text('Registro'),
        backgroundColor: Colors.green, // Color naranja
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginProvider.nameController,
              decoration: InputDecoration(
                labelText: 'Nombre Completo',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: loginProvider.emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: loginProvider.phoneController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
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
                UserModel newUser = UserModel(
                  name: loginProvider.nameController.text,
                  type: 'Técnico',
                  email: loginProvider.emailController.text,
                  phone: loginProvider.phoneController.text,
                  password: loginProvider.passwordController.text,
                );

                await loginProvider.saveUserData(newUser);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Registrar',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
