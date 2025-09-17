import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/firebase_auth_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/teams/presentation/pages/teams_page.dart';
import '../../../../features/live_streams/presentation/pages/live_streams_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const TeamsPage(),
    const LiveStreamsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthProvider>(
      builder: (context, authProvider, child) {
        // If user is not authenticated, show login page
        if (!authProvider.isAuthenticated) {
          return const LoginPage();
        }

        // If user is authenticated, show main app with bottom navigation
        return Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Teams'),
              BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
