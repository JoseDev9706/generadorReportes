import 'package:flutter/material.dart';
import 'package:generadorreportes/features/login/display/providers/login_provider.dart';
import 'package:generadorreportes/features/login/display/screens/login_screen.dart';
import 'package:generadorreportes/features/get_reports/display/providers/reports_provider.dart';
import 'package:generadorreportes/features/user_details/display/providers/profile_provider.dart';
import 'package:generadorreportes/widgets/main_screen.dart';
import 'package:provider/provider.dart';

import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ReportsProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(
            create: (context) => ProfileProvider(
                  Provider.of<LoginProvider>(context, listen: false),
                )),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppWrapper(),
      ),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    // Verificar si hay un usuario almacenado en SharedPreferences
    Future<bool> isUserLoggedIn() async {
      final user = await loginProvider.getUserData();

      return user != null;
    }

    return FutureBuilder<bool>(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return snapshot.data == true ? const MainScreen() : LoginPage();
        }
      },
    );
  }
}
