import 'package:flutter/material.dart';
import 'signin_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration and Sign-In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isStudent = true; // Default to student registration
  bool isStaff = false; // Default to not being a staff member
  TextEditingController staffIdController =
      TextEditingController(); // For staff ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
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
            // If the user selects 'Staff', ask for Staff ID
            if (isStaff) ...[
              TextField(
                controller: staffIdController,
                decoration: InputDecoration(
                  labelText: 'Staff ID',
                ),
              ),
            ],
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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
              onPressed: () {
                final name = nameController.text;
                final email = emailController.text;
                final password = passwordController.text;

                if ((isStudent ||
                        (isStaff && staffIdController.text.isNotEmpty)) &&
                    name.isNotEmpty &&
                    email.isNotEmpty &&
                    password.isNotEmpty) {
                  // All fields are filled, navigate to the SignInPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignInScreen(isStudent: isStudent, isStaff: isStaff),
                    ),
                  );
                } else {
                  // Show an error dialog if any field is empty.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Validation Error'),
                        content: Text('Please fill in all fields.'),
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
              child: Text('Register'),
            ),
            SizedBox(height: 16.0), // Add some spacing
            Text(
              'Already have an account? ',
              style: TextStyle(fontSize: 16.0),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the SignInPage when "Sign In" is tapped.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SignInScreen(isStudent: isStudent, isStaff: isStaff),
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
    );
  }
}
