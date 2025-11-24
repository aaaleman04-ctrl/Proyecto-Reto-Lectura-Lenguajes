import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBarApp extends StatelessWidget {
  final Widget child;

  const NavigationBarApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;

    if (location.startsWith('/home')) currentIndex = 0;
    if (location.startsWith('/profile')) currentIndex = 1;

    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Reto Lectura"),
        backgroundColor: Colors.black45,
      ),
      body: child,

      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.deepOrangeAccent,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
