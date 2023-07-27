

import 'package:flutter/material.dart';
import 'package:text_to_video/gender.dart';
import 'package:text_to_video/videowithBackgroundAudio.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAudio = false;
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;


    return Scaffold(
      body: isAudio
          ? VideoWithBackgroundAudio()
          : SingleChildScrollView(
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
                                  TextField(
                                    controller: myController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          gapPadding: 10,
                                        ),
                                        filled: true,
                                        focusColor: Colors.black,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          gapPadding: 10,
                                        ),
                                        contentPadding: EdgeInsets.all(10),
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: "Type in your text",
                                        fillColor: Colors.white70),
                                  ),

                                ]),
                              ),
                            ),
                            Container(
                              child: Column(children: [

                                TextButton(
                                    onPressed: ()  {
                                      //
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectGender(text: myController.text.toString() )));

                                    },
                                    child: const Text("Proceed to Gender Selection.")),
                                TextButton(
                                    onPressed: ()  {
                                      //
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                          VideoWithBackgroundAudio()
                                          ));

                                    },
                                    child: const Text("Convert From Audio.")),

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
