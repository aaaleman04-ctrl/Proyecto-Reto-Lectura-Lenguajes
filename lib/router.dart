import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/views/book_detail_view.dart';
import 'package:lectura_app/views/home_page.dart';
import 'package:lectura_app/views/profile_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    // Ruta principal con BottomNavigationBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Branch para Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        // Branch para Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    
    // Ruta para detalles del libro (fuera del BottomNavBar)
    GoRoute(
      path: '/book-detail/:bookId',
      builder: (context, state) {
        final bookId = state.pathParameters['bookId']!;
        return BookDetailView(bookId: bookId);
      },
    ),
  ],
);

// MainScreen con BottomNavigationBar
class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Placeholder screens (reemplazar con tus archivos reales)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}

class BookDetailView extends StatelessWidget {
  final String bookId;

  const BookDetailView({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Detail')),
      body: Center(child: Text('Book ID: $bookId')),
    );
  }
}