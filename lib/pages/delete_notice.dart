import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteNoticeScreen extends StatefulWidget {
  @override
  _DeleteNoticeScreenState createState() => _DeleteNoticeScreenState();
}

class _DeleteNoticeScreenState extends State<DeleteNoticeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Notice> notices = [];

  @override
  void initState() {
    super.initState();
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    try {
      // Get a reference to the "Notices" collection in Firestore
      CollectionReference noticesRef = firestore.collection('Notices');

      // Fetch notices from Firestore
      QuerySnapshot querySnapshot = await noticesRef.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Check if 'title' and 'content' fields exist in the document
        if (data.containsKey('title') && data.containsKey('content')) {
          String title = data['title'] as String;
          String content = data['content'] as String;

          setState(() {
            notices.add(Notice(
              title: title,
              content: content,
              documentId: doc.id, // Store the document ID
            ));
          });
        } else {
          // Handle the case where 'title' and 'content' fields are missing
          // or not a string
          print('Notice data is missing required fields.');
        }
      }
    } catch (e) {
      print('Error fetching notices: $e');
    }
  }

  Future<void> deleteNotice(String documentId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this notice?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                // User confirmed the deletion, proceed to delete the notice
                await firestore.collection('Notices').doc(documentId).delete();

                // Update the list of notices by removing the deleted notice
                setState(() {
                  notices
                      .removeWhere((notice) => notice.documentId == documentId);
                });

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Notices'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: notices.map((notice) {
                return Card(
                  child: ListTile(
                    title: Text(notice.title),
                    subtitle: Text(notice.content),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Delete the notice when the delete button is pressed
                        deleteNotice(notice.documentId);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Notice {
  final String title;
  final String content;
  final String documentId;

  Notice({
    required this.title,
    required this.content,
    required this.documentId,
  });
}
