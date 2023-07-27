import 'package:flutter/material.dart';
import 'package:text_to_video/Language.dart';

class SelectGender extends StatefulWidget {
  String text;
   SelectGender({super.key,required this.text});

  @override
  State<SelectGender> createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {

  String genvalue = "Select Gender";
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
                                value: genvalue,
                                // Step 4.
                                items: <String>[
                                  "Select Gender",
                                  'Male',
                                  'Female',
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
                                    genvalue = newValue!;
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
                              onPressed: ()  {
                                //
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectLanguage(text: widget.text,gender: genvalue,)));

                              },
                              child: const Text("Proceed To Language Selection.")),

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
