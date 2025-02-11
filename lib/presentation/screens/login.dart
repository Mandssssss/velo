import 'package:flutter/material.dart';
import 'package:velo/core/configs/theme/app_colors.dart';
import 'package:velo/core/configs/theme/app_fonts.dart';
import 'package:velo/presentation/screens/forgot_password.dart';
import 'package:velo/presentation/screens/signup.dart';
import 'package:velo/presentation/widgets/reusable_wdgts.dart';
import 'package:velo/data/sources/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      await AuthService.login(
        context: context,
        emailController: emailController,
        passwordController: passwordController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(),
                CustomTitleText(text: 'LOGIN'),
                const SizedBox(height: 32),

                // Email Input
                CustomInputField(
                  label: 'EMAIL',
                  controller: emailController,
                  hintText: 'ENTER EMAIL',
                ),

                const SizedBox(height: 16),

                // Password Input with validation
                CustomInputField(
                  label: 'PASSWORD',
                  controller: passwordController,
                  hintText: 'ENTER PASSWORD',
                  obscureText: true,
                ),

                const SizedBox(height: 2),

                // Forgot Password Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppFonts.medium.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 64),

                // Login Button
                Center(
                  child: CustomButton(
                    text: 'LOGIN',
                    onPressed: _login,
                  ),
                ),

                const SizedBox(height: 24),
                Center(child: CustomDivider()),
                const SizedBox(height: 24),

                // Google Login
                Center(
                  child: CustomButton(
                    text: 'With Google',
                    onPressed: () {},
                    iconPath: 'assets/images/Google.png',
                  ),
                ),

                const SizedBox(height: 24),

                // Signup Navigation
                AccountNavigationRow(
                  questionText: "Don't have an account?",
                  actionText: "Sign Up",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Signup()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
