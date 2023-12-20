import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:gallery_saver/gallery_saver.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _scanning = false;
  String _extractText = '';
  late File _pickedImage = File(''); // Initialize with an empty file

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _scanning = true;
    });
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      _pickedImage = File(pickedImage.path);
      _extractText = await FlutterTesseractOcr.extractText(_pickedImage.path);

      // Save the image to gallery
      await GallerySaver.saveImage(_pickedImage.path);
    }
    setState(() {
      _scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text('OCR'),
      ),
      body: ListView(
        children: [
          _pickedImage.path.isEmpty
              ? Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 100,
                  ),
                )
              : Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: FileImage(_pickedImage),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent, // Warna latar belakang tombol
                  ),
                  child: Text(
                    'Pick Image',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent, // Warna latar belakang tombol
                  ),
                  child: Text(
                    'Take Photo',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : Icon(
                  Icons.done,
                  size: 40,
                  color: Colors.green,
                ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _extractText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
