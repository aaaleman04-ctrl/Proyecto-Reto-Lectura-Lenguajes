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
    String password2 = password2Controller.text.trim();


    if (name.isEmpty || email.isEmpty || phone.isEmpty || password1.isEmpty || password2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Todos los campos son obligatorios")),
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

    if (password1 != password2) {
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
        content: Text('Password is not valid'))
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
      backgroundColor: const Color(0xFFf3f4f6),
      appBar: AppBar(
        title: const Text("Registro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            CustomTextField(
              label: "Nombre completo",
              controller: nameController,
              prefixIcon: Icon(Icons.person_2_outlined),
            ),
            CustomTextField(
              label: "Correo institucional",
              controller: emailController,
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            CustomTextField(
              label: "Teléfono",
              controller: phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icon(Icons.phone),
            ),
            TextField(
                controller: password1Controller,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: "Contraseña (número de cuenta)",
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              TextField(
                controller: password2Controller,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: "Confirmar Contraseña",
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Registrar", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
