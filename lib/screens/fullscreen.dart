import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScreen extends StatefulWidget {
  var link;
  FullScreen(this.link);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  var setwallRowOpened = false;
  var progWidth = 0.0;
  var progressText = "WallPapers";

  static const platform = MethodChannel("com.flutter.epic/epic");

// function to store image to gallery
  _save() async {
    setState(() {
      progWidth = 40.0;
    });
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio()
          .get(widget.link, options: Options(responseType: ResponseType.bytes));

      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

      return result;
    } else if (status.isDenied) {
      throw ("You need to give storage permission");
    } else if (status.isRestricted) {
      openAppSettings();
    }
  }

// function to save the image in local/ temp memory
  Future _download(var type, var width) async {
    Dio dio = Dio();
    try {
      var dir = await getTemporaryDirectory();
      await dio.download(widget.link, "${dir.path}/wallpix.jpeg",
          onReceiveProgress: (rec, total) {
        var progress;
        setState(() {
          progress = (rec / total) * 100;
          // progressText = progress.toString();
          progWidth = (progress / 100) * width;
        });
        if (progress == 100) _setWallpaper(type);
      });
    } catch (_) {}
  }

  // This function will ber called when the image is saved to the local memory and ready to set Wallper
  Future _setWallpaper(var type) async {
    try {
      var result = await platform.invokeMethod("setWall", "wallpix.jpeg $type");
      setState(() {
        progressText = "Wallpaper Set Sucessfully";
      });
    } on PlatformException catch (_) {
      setState(() {
        progressText = "Failed to Set Wallpaper";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //  For full screen image
          Column(
            children: [
              Expanded(
                flex: 4,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      setwallRowOpened = false;
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: InteractiveViewer(
                        child:
                            Image.network(widget.link, fit: BoxFit.fitWidth)),
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(
                  height: 10,
                ),
              )
            ],
          ),

          //  Functionalities Card
          Material(
              elevation: 20,
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),

                    setwallRowOpened == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    var u = await _save();
                                    if (u != null) {
                                      setState(() {
                                        progWidth = width;
                                        progressText =
                                            "Wallpaper saved sucessfully";
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.file_download,
                                    color: Colors.black,
                                    size: 26,
                                  )),
                              FilterChip(
                                  label: const Text('Set Wallpaper',
                                      style: TextStyle(color: Colors.black)),
                                  onSelected: (bool value) {
                                    // open the set wallpaper options

                                    setState(() {
                                      setwallRowOpened = true;
                                    });
                                  },
                                  backgroundColor: Colors.white,
                                  avatar: const Icon(Icons.color_lens)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.black,
                                    size: 26,
                                  )),
                            ],
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // button for setting wallpaper at Homescreen

                                InkWell(
                                  onTap: () {
                                    _download("home", width);
                                  },
                                  child: Container(
                                      height: 33,
                                      alignment: Alignment.center,
                                      width: width / 3.5,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Text(
                                        'HOMESCREEN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),

                                // Button for lockscreen
                                InkWell(
                                  onTap: () {
                                    _download("lock", width);
                                  },
                                  child: Container(
                                      height: 33,
                                      alignment: Alignment.center,
                                      width: width / 3.5,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Text(
                                        'LOCKSCREEN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),

                                // Button for both the screens
                                InkWell(
                                  onTap: () {
                                    _download("both", width);
                                  },
                                  child: Container(
                                      height: 33,
                                      alignment: Alignment.center,
                                      width: width / 3.5,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Text(
                                        'BOTH',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                )
                              ],
                            ),
                          ),

                    // set wallpaper and download wallpaper progress indicator
                    Stack(
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.1),
                        ),
                        AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 50,
                          ),
                          height: 50,
                          width: progWidth,
                          color: Colors.cyan,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 50,
                          child: Center(
                            child: Text(
                              progressText,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
