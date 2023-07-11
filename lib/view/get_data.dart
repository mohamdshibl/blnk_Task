
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ScanIdScreen extends StatefulWidget {
  @override
  State<ScanIdScreen> createState() => _ScanIdScreenState();
}
class _ScanIdScreenState extends State<ScanIdScreen> {

  File? _image;
  String txt= '';

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final areaController = TextEditingController();
  final landlineController = TextEditingController();
  final mobileController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // Show an error message to the user or handle the error appropriately
    }
  }


  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    areaController.dispose();
    landlineController.dispose();
    mobileController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
            labelText: "firstName",
            fillColor: Colors.white,
            border:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
              ),
            ),
          ),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: areaController,
                decoration: InputDecoration(
                  labelText: "area",
                  fillColor: Colors.white,
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                    ),
                  ),
              ),
              ),
              TextField(
                controller: landlineController,
                decoration: InputDecoration(labelText: 'Landline',
                    enabledBorder:OutlineInputBorder(borderSide:
                    BorderSide(width: 3, color: Colors.purple), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),) ),
              ),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
              ),
              ElevatedButton(
                onPressed: submitForm,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _image = null;
                  _pickImage(ImageSource.camera).then((value) {
                    if (_image != null) {
                      //
                    }
                  });
                },
                child: const Text('Pick image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _image = null;
                  _pickImage(ImageSource.gallery).then((value) {
                    if (_image != null) {
                     //
                    }
                  });
                },
                child: const Text('Pick image from gallery'),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.green.shade100,
                child: Center(
                  child: (_image != null)
                      ? Image.file(_image!)
                      : Icon(Icons.add_a_photo, size: 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void submitForm() {
    // Get the entered values
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final address = addressController.text;
    final area = areaController.text;
    final landline = landlineController.text;
    final mobile = mobileController.text;

    // Perform further processing or submit the form data
    // You can store it in a Google Spreadsheet or perform other actions
    // For now, we'll print the values to the console
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Address: $address');
    print('Area: $area');
    print('Landline: $landline');
    print('Mobile: $mobile');

    // Clear the text fields
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
    areaController.clear();
    landlineController.clear();
    mobileController.clear();
  }
}