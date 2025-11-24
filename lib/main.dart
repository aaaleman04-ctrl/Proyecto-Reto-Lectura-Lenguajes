import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/views/forgot_password.dart';
import 'package:lectura_app/views/home_page.dart';
import 'package:lectura_app/views/login_page.dart';
import 'package:lectura_app/views/profile_page.dart';
import 'package:lectura_app/views/register_page.dart';
import 'package:lectura_app/widgets/home_page/navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Reto Lectura',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
      ),
      routerConfig: GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: "/login",
            name: "login",
            builder: (context, state) => LoginPage(),
            routes: [
              GoRoute(
                path: "/forgot",
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
                builder: (context, state) => HomePage()
                ),
                GoRoute(
                  path: "/profile",
                  builder: (context, state) => ProfilePage()
                )
            ])
        ],
      ),
    );
  }
}
