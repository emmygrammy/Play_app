import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key, 
  required this.currentUserId});
  
  final String currentUserId;

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(3, (index) => TextEditingController());
  final List<File?> _optionImages = List.generate(3, (index) => null);
  bool _isLoading = false;

  void submitPoll() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a poll title')),
      );
      return;
    }
    for (var controller in _optionControllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter all option names')),
        );
        return;
      }
    }
    // Require all images to be selected
    for (var image in _optionImages) {
      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload an image for every option')),
        );
        return;
      }
    }
    setState(() { _isLoading = true; });
    try {
      final pollDoc = await FirebaseFirestore.instance.collection('polls').add({});
      final pollId = pollDoc.id;
      final List<Map<String, dynamic>> options = [];
      for (int i = 0; i < 3; i++) {
        String imageUrl = '';
        if (_optionImages[i] != null) {
          imageUrl = await uploadImage(_optionImages[i], pollId, i);
        }
        options.add({
          'name': _optionControllers[i].text,
          'imageUrl': imageUrl,
        });
      }
      await pollDoc.set({
        'title': _titleController.text,
        'options': options,
        'createdBy': widget.currentUserId,
        'createdAt': DateTime.now(),
      });
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Poll created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create poll: \$e')),
      );
    }
  }

  Future<String> uploadImage(File? image, String pollId, int optionIndex) async {
    try {
      if (image == null) {
        throw Exception('No image selected');
      }
      final ref = FirebaseStorage.instance
          .ref()
          .child('polls')
          .child(pollId)
          .child('option_\$optionIndex.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: \$e');
      return '';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Poll'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all( 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Poll Title',
                      ),
                    ),
                  ),
        
                  for (int i = 0; i < 3; i++)
                  Container(
                    margin: EdgeInsets.all( 10.0),
                    padding: EdgeInsets.all( 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _optionControllers[i],
                            decoration: InputDecoration(
                              labelText: 'Option ${i + 1} name',
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        _optionImages[i] != null
                        ? Image.file(_optionImages[i]!, height: 50, width: 50, fit: BoxFit.cover)
                        : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.image),
                            onPressed: () async {
                              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  _optionImages[i] = File(pickedFile.path);
                                });
                              }
                            },
                          ),
                        ),
                       

                      ],
                    ),
                  ),
                   SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : submitPoll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 0,
                    ),
                    child: Text('submit poll ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}