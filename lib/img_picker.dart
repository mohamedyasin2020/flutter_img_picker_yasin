import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker'),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () {
                    _delete();
                  },
                  child: Text("Delete")),
              PopupMenuItem(value: 1, child: Text("Share")),
            ],
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                _shareInfo();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _imageFile == null
                  ? Text('No Image selected')
                  : Image.file(_imageFile!),
              ElevatedButton(
                onPressed: () {
                  print('Image pick from gallery button is clicked');
                  _imageFrom(ImageSource.gallery);
                },
                child: Text('Image pick from gallery'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Image pick from camera button is clicked');
                  _imageFrom(ImageSource.camera);
                },
                child: Text('Image pick from Camera'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _imageFrom(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        } else {
          print('No image clicked');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  _shareInfo() async {
    print("-------->share");
    if (_imageFile != null) {
      print("Share option is working");
      await Share.share(_imageFile!.path);
    } else {
      print("No image selected to share");
    }
  }

  void _delete() {
    setState(() {
      _imageFile = null;
    });
  }
}
