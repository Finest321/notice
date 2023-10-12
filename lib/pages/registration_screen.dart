import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore library
import 'package:flutter_app/pages/signin_page.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  TextEditingController staffIdController =
      TextEditingController(); // For staff ID
  TextEditingController regNumberController =
      TextEditingController(); // For student registration number

  bool isStudent = true; // Default to student registration
  bool isStaff = false; // Default to not being a staff member

  String staffIdErrorText = ''; // Error text for Staff ID validation
  String emailErrorText = ''; // Error text for email validation
  String registrationStatus = ''; // Registration status message

  // Function to handle user registration
  Future<void> registerUser() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final staffId = staffIdController.text;
    final regNumber = regNumberController.text;

    // Regular expression to validate email
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // After successful registration, store user data in Firebase Firestore
      final user = userCredential.user;
      if (user != null) {
        final userRole = isStudent ? 'student' : 'staff';

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'role': userRole,
          'password': password, // Don't store actual password, just for example
          'username': name,
        });
      }

      // Registration is successful; update the registration status
      setState(() {
        registrationStatus = 'Registration Successful';
      });

      // Show registration success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text('Your registration was successful.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // Navigate to the SignInPage
                  // Pass user role information to the SignInScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(
                        isStudent: isStudent,
                        isStaff: isStaff,
                      ),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle registration error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Error'),
            content: Text('Failed to register: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Registration'),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                DropdownButtonFormField(
                  value: isStudent ? 'Student' : 'Staff',
                  items: [
                    DropdownMenuItem(
                      value: 'Student',
                      child: Text('Student'),
                    ),
                    DropdownMenuItem(
                      value: 'Staff',
                      child: Text('Staff'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      isStudent = value == 'Student';
                      isStaff = value == 'Staff';
                    });
                  },
                ),
                if (isStaff) ...[
                  TextField(
                    controller: staffIdController,
                    decoration: InputDecoration(
                      labelText: 'Staff ID',
                      errorText:
                          staffIdErrorText.isNotEmpty ? staffIdErrorText : null,
                    ),
                  ),
                ],
                if (isStudent) ...[
                  TextField(
                    controller: regNumberController,
                    decoration: InputDecoration(
                      labelText: 'Registration Number',
                    ),
                  ),
                ],
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText:
                        emailErrorText.isNotEmpty ? emailErrorText : null,
                  ),
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
                  onPressed: registerUser,
                  child: Text('Register'),
                ),
                SizedBox(height: 16.0),
                Text(
                  registrationStatus, // Display registration status message
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.green, // Change color to green for success
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(
                          isStudent: isStudent,
                          isStaff: isStaff,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
