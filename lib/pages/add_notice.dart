import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'post_notice.dart'; // Import the PostNoticeScreen

class AddNoticeScreen extends StatefulWidget {
  @override
  _AddNoticeScreenState createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> resultList = [];

    try {
      // Use the ImagePicker to select multiple images
      resultList = await _picker.pickMultiImage();
    } on Exception catch (e) {
      // Handle exception if image picking fails
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      _selectedImages.addAll(resultList);
    });
  }

  Future<void> _postNotice() async {
    // Check if there is at least 1 selected image and no more than 10
    if (_selectedImages.length < 1 || _selectedImages.length > 10) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Please select between 1 and 10 images before posting.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Implement navigation to the PostNoticeScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostNoticeScreen(selectedImages: _selectedImages),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notice'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 32.0), // Add space between app bar and button

              // "Select Images" button with smaller size
              ElevatedButton(
                onPressed: () {
                  _pickImages(); // Open image picker when pressed
                },
                child: Text(
                  'Select Images',
                  style: TextStyle(fontSize: 16.0), // Decrease font size
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(150, 40),
                  ), // Decrease button size
                ),
              ),

              SizedBox(height: 16.0),

              // Display selected images in a GridView
              _selectedImages.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns in the grid
                        ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Image.file(
                                File(_selectedImages[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _removeImage(index);
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : SizedBox(),

              SizedBox(height: 16.0),

              // "Post Notice" button at the bottom
              ElevatedButton(
                onPressed: () {
                  _postNotice(); // Implement navigation to the PostNoticeScreen
                },
                child: Text(
                  'Post Notice',
                  style: TextStyle(fontSize: 18.0), // Increase font size
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(200, 50),
                  ), // Increase button size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
