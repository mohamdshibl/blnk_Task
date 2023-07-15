import 'dart:io';
import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import '../constants/custom_widget.dart';
import '../constants/utils.dart';
import '../model/user_model.dart';
import '../shared/remote/Gsheets.dart';
import '../shared/remote/gphotos.dart';

class ScanIdScreen extends StatefulWidget {
  @override
  State<ScanIdScreen> createState() => _ScanIdScreenState();
}

class _ScanIdScreenState extends State<ScanIdScreen> {
  String? _frontImage;
  String? _backImage;
  String? _frontId;
  String? _backId;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final areaController = TextEditingController();
  final landlineController = TextEditingController();
  final mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                SizedBox(height: 5),
                CustomTextField(
                  controller: firstNameController,
                  labelText: 'First Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your First name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: lastNameController,
                  labelText: 'Last Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your Last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: addressController,
                  labelText: 'Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your Address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: areaController,
                  labelText: 'Area',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your Area';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: landlineController,
                  labelText: 'Landline',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Landline Number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: mobileController,
                  labelText: 'Mobile Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your Mobile Number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    _detectIdCard();
                  },
                  child: const Text('Pick front image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_frontId != null && _backId != null ) {
                        _submit();
                        _clearFields();
                      }else {
                        fillPhoto(context);
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: (_frontImage != null)
                        ? Image.file(File(_frontImage!))
                        : Image.asset(
                            AssetsImages.frontID,
                          ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _detectIdCard();
                  },
                  child: const Text('Pick back image'),
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: (_backImage != null)
                        ? Image.file(File(_backImage!))
                        : const Icon(Icons.add_a_photo, size: 60),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _clearFields();
                      _frontImage = null;
                      _backImage = null;
                    });
                  },
                  child: const Text('reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        androidScanTitle: 'Scanning',
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() async {
      if (_frontImage == null) {
        _frontImage = imagePath;
        _frontId = path.basename(imagePath);
        File file = File(imagePath);
        await PhotoUploader.uploadImageToDrive(file);
      } else {
        _backImage = imagePath;
        _backId = _frontId = path.basename(imagePath);
      }
    });
  }

  void _submit() async {
    final list = {
      UserFields.firstName: firstNameController.text,
      UserFields.lastName: lastNameController.text,
      UserFields.address: addressController.text,
      UserFields.area: areaController.text,
      UserFields.landline: landlineController.text,
      UserFields.mobile: mobileController.text,
      UserFields.frontId: _frontId,
      UserFields.backId: _backId,
    };
    await GoogleSheets.insertNewRow([list]);
  }

  void _clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
    areaController.clear();
    landlineController.clear();
    mobileController.clear();
  }

  void fillPhoto(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text('You must take id Scan',style: TextStyle(fontSize: 12),),
        action: SnackBarAction(
          label: 'ok', onPressed: scaffold.hideCurrentSnackBar,),
      ),
    );
  }
}
