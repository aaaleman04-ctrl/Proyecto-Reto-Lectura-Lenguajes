import 'package:flutter/material.dart';
import 'package:lectura_app/widgets/login_register/custom_text_field.dart';

class ForgotPassword extends StatelessWidget {

  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text("Forgot Password",
              style: TextStyle(
                color: Colors.white
              ),
              ),
              SizedBox(height: 15),
              Text("Enter your email or username and we'll send you instructions on how to reset your password.",
              style: TextStyle(
                color: Colors.white
              ),
              ),
              SizedBox(height: 15),
              CustomTextField(
                label: "Email or username", 
                controller: emailController, 
                isPassword: false,
                 keyboardType: TextInputType.emailAddress),
                 SizedBox(height: 100,),
          
          ElevatedButton(
            onPressed: () {}, 
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
          Colors.white
              )
            ),
            child: Text("Send", 
            style: TextStyle(
              color: Colors.black
            ),
            )
          )
            ],
          ),
        ),
      ),
    );
  }

}