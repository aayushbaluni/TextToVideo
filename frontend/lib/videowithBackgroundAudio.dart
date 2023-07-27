import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:text_to_video/Models.dart';

import 'finalScreen.dart';

class VideoWithBackgroundAudio extends StatefulWidget {
  @override
  _VideoWithBackgroundAudioState createState() =>
      _VideoWithBackgroundAudioState();
}

class _VideoWithBackgroundAudioState extends State<VideoWithBackgroundAudio> {

  String gendervalue = "Select Character";
  late File audio;
  bool audioPresent=false;


  Future<void> _pickAudio() async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isDenied) {
        await openAppSettings();
      }
    } else {
      if (await Permission.storage.isDenied) {
        await openAppSettings();
      }
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
       audio = File(result.files.single.path.toString());
     setState(() {
       audioPresent=true;
     });
    } else {
    }
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.7,
                  width: width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Vedio AI.",
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: width * 0.1,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        child: Column(children: [
                          TextButton(
                              onPressed: () async {
                                //
                                _pickAudio();
                              },
                              child: audioPresent? const Text("Audio Selected Click To Change")
                                  :const Text("Add AudioFile"),
                          ),

                        ]),
                      ),

                      Container(
                        child: Column(children: [
                          TextButton(
                              onPressed: () async {
                                //
                             if(audioPresent){
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectModels(audioPath: audio.path)));
                             }
                             else{
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Select Audio First.")));

                             }
                              },
                              child: const Text("Proceed to Select Model.")),

                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
