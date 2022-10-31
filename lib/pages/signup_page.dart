import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const SignUpPage({super.key, required this.onClickedSignUp});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
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
                TextField(
                  controller: emailController,
                  cursorColor: Colors.deepPurple,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(label: Text("Email")),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  cursorColor: Colors.deepPurple,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(label: Text("Password")),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
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
                        fontSize: 20,
                      ),
                      text: "Already have an Account?  ",
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                          style: const TextStyle(
                            fontSize: 25,
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
    );
  }
}
