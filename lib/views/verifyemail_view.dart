import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    final email = user?.isEmailVerified ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
      ),
      body: Column(
        children: [
          Text(
              "We have sent a verification mail to your email, $email.Please verify your email address"),
          const Text("If you have not recived any verfication mail. "),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text("Click Here")),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Not you? Please sign out."))
        ],
      ),
    );
  }
}
