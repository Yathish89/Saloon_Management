import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frebase_signin/reusable_widgets/reusable_widget.dart';
import 'package:frebase_signin/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "SIGN UP",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 244, 192, 140), // Dark brown
              Color.fromARGB(255, 242, 189, 136), // Medium brown
              Color(0xFFCDBA96), // Light brown
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Username",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Email Id",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock,
                  true,
                  _passwordTextController,
                ),
                Text(
                  'Password must be 8 characters ,contain at least one uppercase letter, one numeric digit, and one special character.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                firebaseButton(context, "SIGN UP", () async {
                  String password = _passwordTextController.text;
                  bool isValidPassword = _validatePassword(password);

                  if (!isValidPassword) {
                    _showDialog(
                      context,
                      'Invalid Password',
                      'Password must contain at least one uppercase letter, one numeric digit, and one special character.',
                    );
                    return;
                  }

                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: password,
                    );

                    User? user = userCredential.user;
                    if (user != null) {
                      await user
                          .updateDisplayName(_userNameTextController.text);
                      print("Created New Account");

                      // Show account created dialog
                      _showDialog(
                        context,
                        'Account Created',
                        'Your account has been successfully created!',
                      );

                      // Delay navigation to another screen
                      await Future.delayed(const Duration(seconds: 3));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    }
                  } catch (error) {
                    String errorMessage = error.toString();
                    if (errorMessage
                        .contains('[firebase_auth/email-already-in-use] ')) {
                      _showDialog(
                        context,
                        'Email already exists',
                        'Please use a different email address.',
                      );
                    } else {
                      print("Error: $errorMessage");
                    }
                  }
                }),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _validatePassword(String password) {
    // Regex pattern to validate password
    RegExp pattern = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );

    return pattern.hasMatch(password);
  }
}
