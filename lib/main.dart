import 'package:flutter/material.dart';
import 'package:flutter_app/pages/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Registration App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(), // Use AuthenticationWrapper
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth
          .authStateChanges(), // Listen to user authentication state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Firebase is still initializing, display a loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // User is authenticated, navigate to the registration screen or home screen
          return RegistrationScreen(); // Replace with your registration screen
        } else {
          // User is not authenticated, navigate to the registration screen or login screen
          return RegistrationScreen(); // Replace with your registration screen or login screen
        }
      },
    );
  }
}
