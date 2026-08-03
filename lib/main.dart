import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/channels_screen.dart';
import 'screens/settings_screen.dart';
import 'services/update_service.dart';

void main() {
  runApp(const HeyTVApp());
}

class HeyTVApp extends StatelessWidget {
  const HeyTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeyTV HD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ChannelsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_rounded),
            label: 'Canais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_suggest_rounded),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
