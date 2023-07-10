import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frebase_signin/reusable_widgets/reusable_widget.dart';


class resetPassword extends StatefulWidget {
  const resetPassword({super.key});

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 244, 192, 140), // Dark brown
            Color.fromARGB(255, 242, 189, 136), // Medium brown
            Color(0xFFCDBA96), // Light brown
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email Id", Icons.person_outline,
                        false, _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseButton(context, "Reset Password", () {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: _emailTextController.text)
                          .then((value) => Navigator.of(context).pop());
                    })
                  ],
                )),
          )),
    );
  }
}
