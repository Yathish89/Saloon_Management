import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:frebase_signin/screens/SplashScreen_page.dart';
import 'package:frebase_signin/utils/notifi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/signin_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  NotificationService().initNotification();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  final bool isLoggedIn;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String initialRoute;

  @override
  void initState() {
    super.initState();
    initialRoute = '/splash'; // Set the splash screen as the initial route
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Add a delay for the splash screen
    setState(() {
      initialRoute = widget.isLoggedIn
          ? '/home'
          : '/signin'; // Navigate to the appropriate screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Your theme data here
      ),
      initialRoute: initialRoute,
      routes: {
        '/splash': (context) => SplashScreen(), // Add the splash screen route
        '/signin': (context) => SignInScreen(),
        '/home': (context) => HomeScreen(username: ''),
      },
    );
  }
}
