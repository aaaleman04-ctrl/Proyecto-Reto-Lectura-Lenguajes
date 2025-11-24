import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lectura_app/widgets/login_register/custom_text_field.dart';
import 'package:lectura_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (context.mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  void _login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fields cannot be empty")));
      return;
    }

    if (!email.endsWith("@unah.hn")) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email is not valid")));
      return;
    }

    //vamos a suponer que la contra es esta, de mientras agregamos una base de datos
    if (password != "12345") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password is not valid")));
      return;
    }

    context.goNamed("home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: 150),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Log in with Google",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Log in with Facebook",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: Container(height: 1, color: const Color(0xFFE5E7EB)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Container(height: 1, color: const Color(0xFFE5E7EB)),
                ),
              ],
            ),
            SizedBox(height: 25),
            CustomTextField(
              label: "Email or username",
              controller: emailController,
              isPassword: false,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 30),
            TextField(
              controller: passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: () => setState(() => showPassword = !showPassword),
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            SizedBox(height: 35),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
              ),
              onPressed: _login,
              child: Text(
                "Log in",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.pushNamed("forgot");
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 100),
            TextButton(
              onPressed: () {
                context.pushNamed("register");
              },
              child: Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                  color: Colors.white,
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
