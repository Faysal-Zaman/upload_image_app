import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
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
                  "Sign in",
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
                  onPressed: signIn,
                  icon: const Icon(
                    Icons.lock_open,
                    size: 32,
                  ),
                  label: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: const TextSpan(
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      text: "No Account?  ",
                      children: [
                        TextSpan(
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                          ),
                          text: "Sign Up",
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
