import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../utils.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const SignUpPage({super.key, required this.onClickedSignUp});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    //Navigator.of(context) is not working...
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.deepPurple,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      label: Text("Email"),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email == null && EmailValidator.validate(email!)
                            ? 'Enter a valid email'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    cursorColor: Colors.deepPurple,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(label: Text("Password")),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? 'Enter min. 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: signUp,
                    icon: const Icon(
                      Icons.lock_open,
                      size: 32,
                    ),
                    label: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        text: "Already have an Account?  ",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              decoration: TextDecoration.underline,
                            ),
                            text: "Sign In",
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
