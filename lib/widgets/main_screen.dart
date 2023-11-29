import 'package:flutter/material.dart';
import 'package:generadorreportes/features/get_reports/display/providers/reports_provider.dart';
import 'package:provider/provider.dart';

import '../core/utils/ui_utils.dart';
import '../features/home/screens/home_screen.dart';
import '../features/get_reports/display/screens/capture_screen.dart';
import '../features/get_reports/display/screens/reports_screen.dart';
import '../features/user_details/display/screens/user_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isLoaded = false;
  UiUtils uiUtils = UiUtils();
  late ReportsProvider reportsProvider;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const CaptureScreen(),
    const ReportScreen(),
    const UserScreen(),
  ];
  @override
  void didChangeDependencies() async {
    if (!isLoaded) {
      isLoaded = true;
      uiUtils.getDeviceSize(context: context);
      reportsProvider = Provider.of<ReportsProvider>(context);
      await reportsProvider.getReportsFromSharedPreferences();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'SSA MÉXICO GENERADOR DE REPORTES',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildBottomNavItem(Icons.home, 'Inicio', 0),
          _buildBottomNavItem(Icons.receipt_long_sharp, 'Capturar Reporte', 1),
          _buildBottomNavItem(
              Icons.app_registration_rounded, 'Ver Reportes', 2),
          _buildBottomNavItem(Icons.account_circle, 'Usuario', 3),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[200],
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.orange,
        selectedLabelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.orange : Colors.black,
      ),
      label: label,
    );
  }
}
