
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'finalScreen.dart';

class SelectModels extends StatefulWidget {
  String audioPath;
   SelectModels({super.key,required this.audioPath});

  @override
  State<SelectModels> createState() => _SelectModelsState();
}

class _SelectModelsState extends State<SelectModels> {

  String gendervalue = "Select Character";
  Future<bool> sendAudioToBackend() async {
    final url = 'http://10.0.2.2:5000/used_audio'; // Replace with the URL of your Flask backend

    try {
      final dio = Dio();

      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(widget.audioPath, filename: 'audio.mp3'),
        "character":gendervalue,
      });

      final response = await dio.post(url, data: formData,options: Options(
          headers: {
            'Content-Type':'multipart/form-data'
          }
      ));
      if (response.statusCode == 200) {
        print('Audio sent successfully!');
        print(response.data);
        return true;
      } else {
        print('Failed to send audio. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending audio: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Column(children: [

                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: DropdownButton<String>(
                                // Step 3.
                                value: gendervalue,
                                // Step 4.
                                items: <String>[
                                  'Select Character',
                                  'Male',
                                  'Female',
                                  'Nigerian Male',
                                  'Nigerian Female'
                                ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                // Step 5.
                                onChanged: (String? newValue) {
                                  setState(() {
                                    gendervalue = newValue!;
                                  });
                                },
                              ),
                            ),

                          ]),
                        ),
                      ),
                      Container(
                        child: Column(children: [
                          TextButton(
                              onPressed: () async {
                                //
                                await sendAudioToBackend()
                                    ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VideoDisplay()))
                                    : print("Cannot process");
                              },
                              child: const Text("Convert To Video")),

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
