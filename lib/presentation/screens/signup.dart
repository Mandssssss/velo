import 'package:flutter/material.dart';
import 'package:velo/core/configs/theme/app_colors.dart';
import 'package:velo/core/utils/validators.dart';
import 'package:velo/presentation/widgets/reusable_wdgts.dart';
import 'package:velo/data/sources/auth_service.dart';
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
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() async {
    await AuthService.signup(
      context: context,
      usernameController: usernameController,
      emailController: emailController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogo(),
              CustomTitleText(text: 'SIGN UP'),
              const SizedBox(height: 2),
              CustomInputField(
                label: 'USERNAME',
                controller: usernameController,
                hintText: 'Enter your username',
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: 'EMAIL',
                controller: emailController,
                hintText: 'Enter your email',
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: 'PASSWORD',
                controller: passwordController,
                hintText: 'Enter your password',
                obscureText: true,
                validator: FormValidators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: 'CONFIRM PASSWORD',
                controller: confirmPasswordController,
                hintText: 'Re-enter your password',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomButton(
                  text: 'SIGN UP',
                  onPressed: _signup,
                ),
              ),
              const SizedBox(height: 24),
              Center(child: CustomDivider()),
              const SizedBox(height: 24),
              Center(
                child: CustomButton(
                  text: 'With Google',
                  onPressed: () {},
                  iconPath: 'assets/images/Google.png',
                ),
              ),
              const SizedBox(height: 24),
              AccountNavigationRow(
                questionText: "Already have an account?",
                actionText: "Log In",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
