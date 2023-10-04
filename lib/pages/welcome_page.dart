import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  final bool isStudent;

  WelcomePage({required this.isStudent});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool showActions = false;

  void toggleActions() {
    setState(() {
      showActions = !showActions;
    });
  }

  void signOut() {
    // Implement the sign-out logic here
    // For example, you can navigate back to the sign-in screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, you have been missed!',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            if (!widget.isStudent && showActions) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to add notice
                  // Implement the logic for adding a notice here
                },
                child: Text('Add Notice'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to view notice
                  // Implement the logic for viewing notices here
                },
                child: Text('View Notice'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implement the sign-out logic for staff
                  signOut();
                },
                child: Text('Sign Out'),
              ),
            ],
            if (widget.isStudent && showActions) ...[
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to view notice
                  // Implement the logic for viewing notices here
                },
                child: Text('View Notice'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implement the sign-out logic for students
                  signOut();
                },
                child: Text('Sign Out'),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toggleActions(); // Toggle the display of actions
        },
        child: Icon(
          showActions ? Icons.close : Icons.add,
        ),
      ),
    );
  }
}
