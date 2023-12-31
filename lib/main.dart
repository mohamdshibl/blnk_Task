import 'package:blnk/shared/remote/Gsheets.dart';
import 'package:blnk/view/get_data.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';


void main() async{

  await GoogleSheets.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ScanIdScreen(),
    );
  }
}

