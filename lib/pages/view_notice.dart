import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewNoticesScreen extends StatefulWidget {
  @override
  _ViewNoticesScreenState createState() => _ViewNoticesScreenState();
}

class _ViewNoticesScreenState extends State<ViewNoticesScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
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

          // Check if 'imageURLs' field exists and is a list of strings
          List<String> imageUrls = data['imageURLs'] is List
              ? List<String>.from(data['imageURLs'])
              : [];

          setState(() {
            notices.add(Notice(
              title: title,
              content: content,
              imageUrls: imageUrls,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('View Notices'),
        ),
        body: notices.isEmpty
            ? Center(child: Text('No notices available.'))
            : Padding(
                padding:
                    const EdgeInsets.only(top: 15.0), // Add top padding here
                child: ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    Notice notice = notices[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NoticeDetailScreen(notice: notice),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(notice.title),
                          subtitle: Text(notice.content),
                          leading: notice.imageUrls.isNotEmpty
                              ? Image.network(notice.imageUrls[0])
                              : SizedBox(), // Check for empty image URLs
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}

class Notice {
  final String title;
  final String content;
  final List<String> imageUrls;

  Notice({required this.title, required this.content, required this.imageUrls});
}

class NoticeDetailScreen extends StatelessWidget {
  final Notice notice;

  NoticeDetailScreen({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(notice.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (notice.imageUrls.isNotEmpty)
                Column(
                  children: notice.imageUrls.map((imageUrl) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.network(imageUrl),
                    );
                  }).toList(),
                )
              else
                SizedBox(), // Check for empty image URLs
              Text(notice.content),
            ],
          ),
        ));
  }
}

void main() {
  runApp(MaterialApp(
    home: ViewNoticesScreen(),
  ));
}
