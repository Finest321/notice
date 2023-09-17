import 'package:flutter/material.dart';
import 'welcome_page.dart'; // Import the WelcomePage class

class SignInScreen extends StatefulWidget {
  final bool isStudent;
  final bool isStaff;

  SignInScreen({required this.isStudent, required this.isStaff});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoggedIn = false; // Track login state
  bool isStudent = false; // Track user role
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  @override
  void initState() {
    super.initState();
    isStudent = widget.isStudent; // Initialize user role based on registration
  }

  bool isEmailValid(String email) {
    return emailRegex.hasMatch(email);
  }

  void navigateToWelcomePage() {
    // Replace this with the appropriate navigation logic to WelcomePage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            WelcomePage(isStudent: isStudent), // Pass isStudent to WelcomePage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (!isLoggedIn) ...[
              SizedBox(height: 24.0),
              // Display login fields only if not logged in
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress, // Show email keyboard
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
                onPressed: () {
                  // Replace this logic with your actual login authentication
                  // For simplicity, assume login is successful for any non-empty input
                  final email = emailController.text;
                  final password = passwordController.text;

                  if (isEmailValid(email) && password.isNotEmpty) {
                    setState(() {
                      isLoggedIn = true;
                    });
                    // Navigate to the WelcomePage on successful login
                    navigateToWelcomePage();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Validation Error'),
                          content:
                              Text('Please enter a valid email and password.'),
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
                },
                child: Text('Login'),
              ),
            ],
            // Remove the Welcome message from here
          ],
        ),
      ),
    );
  }
}
