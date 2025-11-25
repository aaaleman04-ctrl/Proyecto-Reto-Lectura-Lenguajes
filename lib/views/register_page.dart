import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lectura_app/widgets/login_register/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final pass1 = password1Controller.text.trim();
    final pass2 = password2Controller.text.trim();

    // ---- VALIDACIONES ----
    if (name.isEmpty || email.isEmpty || phone.isEmpty || pass1.isEmpty) {
      _showError("Fields cannot be empty");
      return;
    }

    if (!email.endsWith("@unah.hn")) {
      _showError("Email must end with @unah.hn");
      return;
    }

    if (pass1 != pass2) {
      _showError("Passwords do not match");
      return;
    }

    if (pass1.length < 6 ||
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pass1)) {
      _showError("Password must have 6+ characters and 1 symbol");
      return;
    }

    setState(() => isLoading = true);

    try {
      // ---- CREAR USUARIO EN FIREBASE ----
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass1,
      );

      final uid = userCredential.user!.uid;

      // ---- GUARDAR DATOS EN FIRESTORE ----
      await _firestore.collection("users").doc(uid).set({
        "name": name,
        "email": email,
        "phone": phone,
        "created_at": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registro exitoso")),
      );

      context.pop(); // regresar a login
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showError(e.message ?? "Error en el registro");
    } catch (e) {
      if (!mounted) return;
      _showError("Unexpected error: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: const Text("Sign up", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            CustomTextField(
              label: "Complete Name",
              controller: nameController,
              prefixIcon: const Icon(Icons.person_2_outlined),
            ),
            CustomTextField(
              label: "Email",
              controller: emailController,
              prefixIcon: const Icon(Icons.mail_outline_rounded),
            ),
            CustomTextField(
              label: "Number",
              controller: phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone),
            ),

            // PASSWORD FIELD
            TextField(
              controller: password1Controller,
              obscureText: !showPassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(showPassword 
                      ? Icons.visibility 
                      : Icons.visibility_off),
                  onPressed: () => setState(() => showPassword = !showPassword),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // CONFIRM PASSWORD
            TextField(
              controller: password2Controller,
              obscureText: !showPassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: "Confirm password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
