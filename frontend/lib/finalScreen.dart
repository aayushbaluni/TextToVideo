import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class VideoDisplay extends StatefulWidget {
  @override
  _VideoDisplayState createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isDownloading = false;
  late String _downloadedFilePath;
  Resolution _selectedResolution = Resolution.vertical;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
        ('http://10.0.2.2:5000/download/output_video.mp4'));
    _initializeVideoPlayerFuture=_videoPlayerController.initialize();
    _videoPlayerController.setLooping(false);
    _videoPlayerController.setVolume(1.0);
    super.initState();
  }



  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
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
                      Container(
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              return AspectRatio(
                                aspectRatio: _videoPlayerController.value.aspectRatio,
                                // Use the VideoPlayer widget to display the video.
                                child: VideoPlayer(_videoPlayerController),
                              );
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () async {
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
                                    if(await Permission.manageExternalStorage.isGranted){
                                      var dir = await DownloadsPathProvider.downloadsDirectory;
                                      if(dir != null){
                                        String savename = "download.mp4";
                                        String savePath = dir.path + "/$savename";
                                        print(savePath);
                                        //output:  /storage/emulated/0/Download/banner.png

                                        try {
                                          await Dio().download(
                                              'http://10.0.2.2:5000/download/output_video.mp4',
                                              savePath,
                                              onReceiveProgress: (received, total) {
                                                if (total != -1) {
                                                  print((received / total * 100).toStringAsFixed(0) + "%");
                                                  //you can build progressbar feature too
                                                }
                                              });
                                          print("Video is saved to download folder.");
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Video Downloaded !")));
                                        } on DioError catch (e) {
                                          print(e.message);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error Occurred.")));
                                        }
                                      }
                                    }else{
                                      print("No permission to read and write.");
                                    }

                                  },
                                  child: const Text("Download Video")),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

enum Resolution { vertical, horizontal }
