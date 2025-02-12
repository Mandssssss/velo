import 'package:flutter/material.dart';
import 'package:velo/core/configs/theme/app_colors.dart';
import 'package:velo/core/utils/validators.dart';
import 'package:velo/presentation/widgets/reusable_wdgts.dart';
import 'package:velo/data/sources/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// 🔹 Email & Password Signup
  void _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseServices.signup(
          context: context,
          usernameController: usernameController,
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: $e")),
        );
      }
    }
  }

  /// 🔹 Google Sign-Up
  void _signInWithGoogle() async {
    try {
      UserCredential? user = await FirebaseServices().signInWithGoogle(context);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signed in as ${user.user?.displayName}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
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
                CustomTitleText(text: 'SIGN UP'),
                const SizedBox(height: 2),

                // Username Input
                CustomInputField(
                  label: 'USERNAME',
                  controller: usernameController,
                  hintText: 'Enter your username',
                ),

                const SizedBox(height: 16),

                // Email Input
                CustomInputField(
                  label: 'EMAIL',
                  controller: emailController,
                  hintText: 'Enter your email',
                ),

                const SizedBox(height: 16),

                // Password Input
                CustomInputField(
                  label: 'PASSWORD',
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obscureText: true,
                  validator: FormValidators.validatePassword,
                ),

                const SizedBox(height: 16),

                // Confirm Password Input
                CustomInputField(
                  label: 'CONFIRM PASSWORD',
                  controller: confirmPasswordController,
                  hintText: 'Re-enter your password',
                  obscureText: true,
                ),

                const SizedBox(height: 24),

                // Signup Button
                Center(
                  child: CustomButton(
                    text: 'SIGN UP',
                    onPressed: _signup,
                  ),
                ),

                const SizedBox(height: 24),
                Center(child: CustomDivider()),
                const SizedBox(height: 24),

                // Google Sign-Up Button
                Center(
                  child: CustomButton(
                    text: 'With Google',
                    onPressed: _signInWithGoogle,
                    iconPath: 'assets/images/Google.png',
                  ),
                ),

                const SizedBox(height: 24),

                // Login Navigation
                AccountNavigationRow(
                  questionText: "Already have an account?",
                  actionText: "Log In",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
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
