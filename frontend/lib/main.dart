import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:text_to_video/finalScreen.dart';
import 'package:text_to_video/home.dart';
import 'package:text_to_video/videowithBackgroundAudio.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
