import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velo/presentation/intro/pages/onboarding.dart';
import 'package:velo/presentation/screens/home.dart';
import 'package:velo/presentation/screens/signup.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF672A2A),
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/', // Set Splash Screen as the first page
      routes: {
        '/': (context) => const SplashScreen(),
        '/getstarted': (context) => const GetStarted(), // Call GetStarted page
        '/home': (context) => const HomePage(),
        '/signup': (context) => const Signup(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, '/getstarted'); // Navigate to GetStarted
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png',
            width: 150, height: 150), // Splash logo
      ),
    );
  }
}
