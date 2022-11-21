import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'Password reset link send! Check your email box.',
              style: GoogleFonts.ptSans(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Okay',
                  style: GoogleFonts.ptSans(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'An error occurred!',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                e.message.toString(),
                style: GoogleFonts.ptSans(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Reset Password',
          style: GoogleFonts.ptSans(
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                  'Enter your email and we\'ll send you a reset link to your email.',
                  style: GoogleFonts.ptSans(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Email',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: resetPassword,
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                'Reset Password',
                style: GoogleFonts.ptSans(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
