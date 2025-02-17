import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velo/presentation/intro/pages/onboarding.dart';
import 'package:velo/presentation/screens/signup.dart';
import 'package:velo/presentation/screens/login.dart';
import 'package:velo/services/brevo_service.dart'; // Import the Brevo service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

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
      home: const SplashScreen(), // Start with SplashScreen
      routes: {
        '/getstarted': (context) => const GetStarted(),
        '/home': (context) => const HomePage(),
        '/signup': (context) => const Signup(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      // Check if user is already logged in
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home'); // Go to Home if logged in
      } else {
        Navigator.pushReplacementNamed(context, '/getstarted'); // Otherwise, Onboarding
      }
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png',
            width: 150, height: 150), // Splash logo
      ),
    );
  }
}

// Update HomePage to include a button to send an email
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final BrevoService brevoService = BrevoService(); // Create instance

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool success = await brevoService.sendEmail(
              "recipient@example.com",
              "Welcome to Velo!",
              "This is a test email from Velo using Brevo API!"
            );

            // Show a Snackbar based on the email result
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? "✅ Email Sent!" : "❌ Failed to Send Email"),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          },
          child: const Text("Send Test Email"),
        ),
      ),
    );
  }
}
