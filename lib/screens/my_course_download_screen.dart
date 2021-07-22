import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';

class MyCourseDownloadScreen extends StatefulWidget {
  static const routeName = '/my-download-screen';
  @override
  _MyCourseDownloadScreenState createState() => _MyCourseDownloadScreenState();
}

class _MyCourseDownloadScreenState extends State<MyCourseDownloadScreen> {

  int progress = 0;


  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    // final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    // if(arguments != null) {
    //   final selectedUrl = arguments['_url'];
    //   final name = arguments['_name'];
    //   return Scaffold();
    // }
    final selectedUrl = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: CustomAppBarTwo(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // Text("Download in Progress "+"$progress"+ "%", style: TextStyle(fontSize: 40),),
            //
            // SizedBox(height: 60,),

            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Download File", style: TextStyle(fontSize: 18),),
              ),
              color: Colors.redAccent,
              textColor: Colors.white,
              onPressed: () async {
                final status = await Permission.storage.request();
                String externalDir = "";
                if (status.isGranted) {
                  if (Platform.isAndroid) {
                    externalDir = "/sdcard/download/";
                  } else {
                    externalDir = (await getApplicationDocumentsDirectory()).path;
                  }

                  try {
                    FileUtils.mkdir([externalDir]);
                    final id = await FlutterDownloader.enqueue(
                      url: selectedUrl,
                      savedDir: externalDir,
                      // fileName: "download1234.pdf",
                      showNotification: true,
                      openFileFromNotification: true,
                    );
                    CommonFunctions.showSuccessToast("Downloading");
                  } catch(e){
                    print(e.getMessage());
                    CommonFunctions.showSuccessToast("Download Error");
                  }

                } else {
                  print("Permission deined");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}