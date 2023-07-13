
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/custom_widget.dart';
import '../constants/utils.dart';

class ScanIdScreen extends StatefulWidget {
  @override
  State<ScanIdScreen> createState() => _ScanIdScreenState();
}
class _ScanIdScreenState extends State<ScanIdScreen> {

  File? _image;
  String? _imagee;
  String? _imageee;
  String txt= '';

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final areaController = TextEditingController();
  final landlineController = TextEditingController();
  final mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _detectIdCard() async {

      bool isCameraGranted = await Permission.camera.request().isGranted;
      if (!isCameraGranted) {
        isCameraGranted =
            await Permission.camera.request() == PermissionStatus.granted;
      }

      if (!isCameraGranted) {
        // Have not permission to camera
        return;
      }

      // Generate filepath for saving
      String imagePath = join((await getApplicationSupportDirectory()).path,
          "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

      try {
        //Make sure to await the call to detectEdge.
        bool success = await EdgeDetection.detectEdge(
          imagePath,
          canUseGallery: true,
          androidScanTitle: 'Scanning', // use custom localizations for android
          androidCropTitle: 'Crop',
          androidCropBlackWhiteTitle: 'Black White',
          androidCropReset: 'Reset',
        );
        print("success: $success");
      } catch (e) {
        print(e);
      }
      if (!mounted) return;
      setState(() {
        if (_imagee==null){
          _imagee = imagePath;
        }else {
          _imageee = imagePath;
        }
      });
    }
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: firstNameController,
                  labelText: 'First Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid first name';
                    }
                    return null;
                  },
                ),

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
                    _detectIdCard();
                    // _pickImage(ImageSource.camera).then((value) {
                    //   if (_image != null) {
                    //     //
                    //   }
                    // });
                  },
                  child: const Text('Pick front image'),
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
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _imagee=null;
                      _imageee=null;
                    });
                  },
                  child: const Text('reset'),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: (_imagee != null)
                        ? Image.file(File(_imagee!))
                        : Image.asset(AssetsImages.frontID,),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _image = null;
                    _detectIdCard();
                    // _pickImage(ImageSource.camera).then((value) {
                    //   if (_image != null) {
                    //     //
                    //   }
                    // });
                  },
                  child: const Text('Pick back image'),
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: (_imageee != null)
                        ? Image.file(File(_imageee!))
                        : const Icon(Icons.add_a_photo, size: 60),
                  ),
                ),
              ],
            ),
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


