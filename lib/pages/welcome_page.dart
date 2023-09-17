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
              'Welcome${widget.isStudent ? '' : ' Staff'}, you have been missed!',
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
                  // Add functionality to modify notice
                  // Implement the logic for modifying a notice here
                },
                child: Text('Modify Notice'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to delete notice
                  // Implement the logic for deleting a notice here
                },
                child: Text('Delete Notice'),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: !widget.isStudent
          ? FloatingActionButton(
              onPressed: () {
                toggleActions(); // Toggle the display of actions
              },
              child: Icon(
                showActions ? Icons.close : Icons.add,
              ),
            )
          : null,
    );
  }
}
