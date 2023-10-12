import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/pages/welcome_page.dart';
import 'package:flutter_app/pages/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> fetchUserRoleFromFirestore(String uid) async {
    try {
      final userDocument =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDocument.exists) {
        final userRole = userDocument.data()?['role'];
        return userRole;
      } else {
        return 'unknown';
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return 'unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final user = snapshot.data;
          if (user != null) {
            fetchUserRoleFromFirestore(user.uid).then((String userRole) {
              if (userRole == 'student') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(isStudent: true),
                  ),
                );
              } else if (userRole == 'staff') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(isStudent: false),
                  ),
                );
              }
            });
          }
        } else {
          return RegistrationScreen();
        }
        return Container();
      },
    );
  }
}
