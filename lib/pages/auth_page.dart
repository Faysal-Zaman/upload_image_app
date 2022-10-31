import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:upload_image_app/pages/signin_page.dart';
import 'package:upload_image_app/pages/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? SignInPage(onClickedSignUp: toggle)
        : SignUpPage(onClickedSignUp: toggle);
  }
}
