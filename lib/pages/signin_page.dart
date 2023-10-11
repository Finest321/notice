import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:flutter_app/pages/registration_screen.dart';
import 'welcome_page.dart';

class SignInScreen extends StatefulWidget {
  final bool isStudent;
  final bool isStaff;

  SignInScreen({required this.isStudent, required this.isStaff});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  bool isEmailValid(String email) {
    return emailRegex.hasMatch(email);
  }

  Future<void> signIn() async {
    final email = emailController.text;
    final password = passwordController.text;

    // Check if email and password are valid
    if (isEmailValid(email) && password.isNotEmpty) {
      try {
        // Sign in with Firebase Authentication
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Successful login, now fetch user details from Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userDocument = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          // Determine the user's role from Firestore document
          final userRole =
              userDocument['role']; // Assumes 'role' is a field in Firestore

          // Navigate to the appropriate screen based on the user's role
          if (userRole == 'student' && widget.isStudent) {
            // User is a student and trying to sign in as a student
            navigateToWelcomePage();
          } else if (userRole == 'staff' && widget.isStaff) {
            // User is a staff member and trying to sign in as staff
            navigateToWelcomePage();
          } else {
            // User role and selection do not match
            // Show an error message or handle it as needed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Role Mismatch'),
                  content: Text('You do not have the required role.'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      } catch (e) {
        // Handle login error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Error'),
              content: Text('Failed to log in: $e'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show validation error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Validation Error'),
            content: Text('Please enter a valid email and password.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void navigateToWelcomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WelcomePage(isStudent: widget.isStudent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: signIn,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            // Add a TextButton for "Don't have an account? Sign up" here
            TextButton(
              onPressed: () {
                // Navigate to the RegistrationScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationScreen(),
                  ),
                );
              },
              child: Text(
                "Don't have an account? "
                "Sign up",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
