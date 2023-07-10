import 'package:flutter/material.dart';
import 'package:frebase_signin/screens/signin_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.fastOutSlowIn,
  );

  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    navigateToHomeScreen();
  }

  navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 211, 151, 94),
              Color.fromARGB(255, 216, 162, 134),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    "assets/images/flutter_icon.png",
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
