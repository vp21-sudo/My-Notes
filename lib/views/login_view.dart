import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';

import '../utils/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter your Email."),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your Password."),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              final router = Navigator.of(context);
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;

                if (user?.emailVerified ?? false) {
                  //user email is verified
                  router.pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  //user email is not verified

                  router.pushNamedAndRemoveUntil(verifyEmail, (route) => false);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  await showErrorDialog(context, "User not found");
                } else if (e.code == "wrong-password") {
                  await showErrorDialog(context, "Wrong Credentials");
                } else {
                  await showErrorDialog(context, 'Error:${e.code}');
                }
              } catch (e) {
                devtools.log("Something bad happened");
                devtools.log(e.toString());
                await showErrorDialog(context, "Error:${e.toString()}");
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Not Registered yet? Register Here."))
        ],
      ),
    );
  }
}
