import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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


  void _register() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password1 = password1Controller.text.trim();


    if (name.isEmpty || email.isEmpty || phone.isEmpty || password1.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fields cannot be empty")),
      );
      return;
    }

    if (!email.endsWith("@unah.hn")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email is not valid"),
        ),
      );
      return;
    }

    if ((password1.length < 6 ||
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password1))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Contraseña debe tener 6 caracteres y 1 símbolo especial",
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Registro exitoso")));

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: const Text("Sign up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            CustomTextField(
              label: "Complete Name",
              controller: nameController,
              prefixIcon: Icon(Icons.person_2_outlined),
            ),
            CustomTextField(
              label: "Email",
              controller: emailController,
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            CustomTextField(
              label: "Number",
              controller: phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icon(Icons.phone),
            ),
            TextField(
                controller: password1Controller,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              

            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _register,
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
              child: const Text("Sign up", style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
