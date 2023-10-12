import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add_notice.dart';
import 'package:flutter_app/pages/logout_screen.dart';

class WelcomePage extends StatefulWidget {
  final bool isStudent;

  WelcomePage({required this.isStudent});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void signOut() {
    // Implement the sign-out logic here
    // For example, you can navigate back to the sign-in screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.home), // Home Icon
            SizedBox(width: 8), // Add some space between the icon and text
            Text('Home'), // Title text
          ],
        ),
        actions: [
          // Overflow menu with three dots
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'item1',
                child: Text('Settings'),
              ),
              PopupMenuItem<String>(
                value: 'item2',
                child: Text('My Profile'),
              ),
              PopupMenuItem<String>(
                value: 'item2',
                child: Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogoutScreen(
                        isStudent: true,
                        isStaff: !true,
                      ),
                    ),
                  );
                },
              ),
              // Add more items as needed
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 65.0), // Add padding to the top
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Grid with 2 rows and 2 columns
            GridView.count(
              crossAxisCount: 2, // 2 columns in the grid
              shrinkWrap: true, // To make GridView scrollable if needed
              children: <Widget>[
                // Staff view
                if (!widget.isStudent) ...[
                  _buildSquareBox(
                    backgroundColor: Color(0xFF004d40), // Blue color
                    title: 'Add Notice',
                    icon: Icons.add,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNoticeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSquareBox(
                    backgroundColor: Color(0xFF002147), // Green color
                    title: 'View Notice',
                    icon: Icons.visibility,
                    onTap: () {
                      // Implement logic for viewing notices here
                    },
                  ),
                  _buildSquareBox(
                    backgroundColor: Color(0xFFb71c1c), // Red color
                    title: 'Delete Notice',
                    icon: Icons.delete,
                    onTap: () {
                      // Implement logic for deleting notices here
                    },
                  ),
                  _buildSquareBox(
                    backgroundColor: Color(0xFFe65100), // Orange color
                    title: 'Modify Notice',
                    icon: Icons.edit,
                    onTap: () {
                      // Implement logic for modifying notices here
                    },
                  ),
                ],
                // Student view
                if (widget.isStudent) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Add padding
                    child: _buildSquareBox(
                      backgroundColor: Color(0xFF002147), // Green color
                      title: 'View Notice',
                      icon: Icons.visibility,
                      onTap: () {
                        // Implement logic for viewing notices here
                      },
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareBox({
    required Color backgroundColor,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Add padding
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 48.0,
                color: Colors.white,
              ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
