import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF8B1D1D)),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous page
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset('assets/images/logo.png', height: 24),
                const SizedBox(height: 40),
                const Text(
                  'Enter Your New Password',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF803434),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'NEW PASSWORD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your new password',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic for resetting the password
                      // Possibly navigate to a success page or back to the login page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF803434),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
