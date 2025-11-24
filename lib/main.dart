import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:lectura_app/views/forgot_password.dart';
import 'package:lectura_app/views/home_page.dart';
import 'package:lectura_app/views/login_page.dart';
import 'package:lectura_app/views/profile_page.dart';
import 'package:lectura_app/views/register_page.dart';
import 'package:lectura_app/widgets/home_page/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Reto Lectura',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: "/login",
            name: "login",
            builder: (context, state) => LoginPage(),
            routes: [
              GoRoute(
                path: "forgot",
                name: "forgot",
                builder: (context, state) => ForgotPassword(),
              ),
              GoRoute(
                path: "/register",
                name: "register",
                builder: (context, state) => RegisterPage(),
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) {
              return NavigationBarApp(child: child);
            },
            routes: [
              GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => HomePage()),
              GoRoute(
                  path: "/profile",
                  name: "profile",
                  builder: (context, state) => ProfilePage())
            ],
          )
        ],
      ),
    );
  }
}
