import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/pages/welcome_page.dart';

class PostNoticeScreen extends StatefulWidget {
  final List<XFile> selectedImages;

  PostNoticeScreen({required this.selectedImages});

  @override
  _PostNoticeScreenState createState() => _PostNoticeScreenState();
}

class _PostNoticeScreenState extends State<PostNoticeScreen> {
  String _title = '';
  String _content = '';
  bool _isUploading = false; // Add a flag to track if uploading is in progress

  Future<void> _uploadImagesAndPostNotice() async {
    List<String> imageUrls = [];

    setState(() {
      _isUploading = true; // Start the uploading process
    });

    try {
      // Upload selected images to Firebase Storage and get their download URLs
      for (var imageFile in widget.selectedImages) {
        String imageUrl =
            await uploadImage(File(imageFile.path), _title, _content);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }
    } catch (error) {
      // Handle the error
      print('Error uploading images: $error');
    } finally {
      setState(() {
        _isUploading = false; // Finish the uploading process
      });

      // Show a confirmation dialog only if images were successfully uploaded
      if (imageUrls.isNotEmpty) {
        bool uploadConfirmed = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm Upload'),
              content: Text('Do you want to upload this notice?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // No
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Yes
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );

        if (uploadConfirmed != null && uploadConfirmed) {
          // Upload the notice to Firestore
          await FirebaseFirestore.instance.collection('Notices').add({
            'title': _title,
            'content': _content,
            'imageURLs': imageUrls,
            'timestamp': FieldValue.serverTimestamp(),
          });

          // Show a success dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Notice Posted'),
                content: Text('Your notice was uploaded successfully.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomePage(
                            isStudent: false,
                          ),
                        ),
                      ); // Navigate to WelcomePage
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  Future<String> uploadImage(
      File imageFile, String title, String content) async {
    String imageUrl = '';

    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child('Notices/${DateTime.now()}.png');

      // Set custom metadata for the image with title and content
      SettableMetadata metadata = SettableMetadata(
        customMetadata: {
          'title': title,
          'content': content,
        },
      );

      UploadTask uploadTask = storageRef.putFile(imageFile, metadata);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      imageUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      // Handle the error
      print('Error uploading image: $error');
    }

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Notice'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16.0),

              // Text field for title
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),

              SizedBox(height: 16.0),

              // Text field for content
              TextField(
                decoration: InputDecoration(labelText: 'Content'),
                onChanged: (value) {
                  setState(() {
                    _content = value;
                  });
                },
              ),

              SizedBox(height: 16.0),

              // Display selected images
              widget.selectedImages.isNotEmpty
                  ? Column(
                      children: widget.selectedImages.map((image) {
                        return Image.file(
                          File(image.path),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    )
                  : SizedBox(),

              SizedBox(height: 16.0),

              // Button to post the notice
              ElevatedButton(
                onPressed: () {
                  _uploadImagesAndPostNotice();
                },
                child: Text('Post Notice'),
              ),

              // Show a loading indicator while uploading
              if (_isUploading)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
