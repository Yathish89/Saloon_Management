import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frebase_signin/reusable_widgets/reusable_widget.dart';
import 'package:frebase_signin/screens/AdminPage_screen.dart';

import 'package:frebase_signin/screens/home_screen.dart';
import 'package:frebase_signin/screens/reset_password.dart';
import 'package:frebase_signin/screens/signup_screen.dart';

import 'package:email_validator/email_validator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _isPasswordValid = true;
  bool _isPasswordVisible = false; // Track the password visibility

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // closing app
        if (FirebaseAuth.instance.currentUser == null) {
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
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
                  logoWidget("assets/images/Hotpot.png"),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      prefixIcon: Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _passwordTextController,
                    obscureText:
                        !_isPasswordVisible, // Toggle password visibility
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle password visibility
                          });
                        },
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      setState(() {
                        _isPasswordValid = _validatePassword(value!);
                      });
                      return '';
                    },
                  ),
                  if (!_isPasswordValid)
                    Text(
                      'Password must contain at least 8 characters, one uppercase letter, one numeric digit, and one special character.',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  forgetPassword(context),
                  firebaseButton(context, "SIGN IN", () async {
                    if (EmailValidator.validate(_emailTextController.text) &&
                        _isPasswordValid) {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text,
                        );
                        if (_emailTextController.text == 'admin@gmail.com' &&
                            _passwordTextController.text == 'Admin@123') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPage()),
                          );
                        } else {
                          //regular user
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                username:
                                    userCredential.user!.displayName ?? '',
                              ),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found' ||
                            e.code == 'wrong-password') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('Incorrect email or password'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'An error occurred while signing in. Please try again later.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    } else {
                      // Invalid email or password
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Invalid Email or Password'),
                            content: Text(
                                'Please enter a valid email and password.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }),
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validatePassword(String value) {
    RegExp pattern = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );
    return pattern.hasMatch(value);
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            "SIGN UP",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => resetPassword()),
        ),
      ),
    );
  }
}
