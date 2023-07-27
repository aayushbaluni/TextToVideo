
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'finalScreen.dart';

class Models extends StatefulWidget {
  String text;
  String language;
  String gender;
  Models({super.key,required this.text,required this.gender,required this.language});

  @override
  State<Models> createState() => _ModelsState();
}

class _ModelsState extends State<Models> {

  String gendervalue = "Select Character";
  Future<bool> speech() async {
    var text = widget.text;
    var language = widget.language;
    String url = "http://10.0.2.2:5000/generate_audio";
    final Map<String, dynamic> data = {
      'input_text': text,
      'voice': widget.gender,
      'language': language,
      "character":gendervalue
    };
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
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
                                await speech()
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
