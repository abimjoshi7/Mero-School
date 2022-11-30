import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../webengage/tags.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  final String? name;
  final Map<String, dynamic> arguments;
  PdfViewerPage(
      {Key? key, required this.path, this.name, required this.arguments});

  @override
  Widget build(BuildContext context) {
    AppProgressDialog _progressDialog = new AppProgressDialog(context);
    File pdf = File(path);
    final DateFormat formatter = DateFormat("'~t'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    var formatted = formatter.format(DateTime.now().toUtc());
    arguments["Certificate Generated Date"] = formatted;
    addEvent(arguments);

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Certificate",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await _progressDialog.show();
                  final data = await pdf.readAsBytes();
                  await writeFile(
                          data,
                          name != null
                              ? "$name-MeroSchoolCertificate.pdf"
                              : "certificate.pdf")
                      .then((val) {
                    Fluttertoast.showToast(msg: "Certificate saved to device");
                    Navigator.pop(context);
                  }).catchError((err) {
                    if (err is FileSystemException) {
                      Fluttertoast.showToast(
                          msg: "Allow permission to save file.");
                    } else {
                      Navigator.pop(context);
                    }
                  }).onError((error, stackTrace) async {
                    Navigator.pop(context);
                  });
                },
                icon: Icon(
                  Icons.download,
                ))
          ]),
      body: Container(
        child: SfPdfViewer.file(pdf),
      ),
    );
  }
}

// void downloadFile(String path) async {
//   var downloadFolder = await getExternalStorageDirectory();
//   await FlutterDownloader.initialize(
//       debug: false // optional: set false to disable printing logs to console
//       );
//   await FlutterDownloader.enqueue(
//     url: "file://" + path,
//     savedDir: downloadFolder!.path,
//     showNotification:
//         true, // show download progress in status bar (for Android)
//     openFileFromNotification:
//         true, // click on notification to open downloaded file (for Android)
//   );
// }

void addEvent(Map<String, dynamic>? arguments) {
  log("$arguments, Logging event");
  WebEngagePlugin.trackEvent(TAG_VIEW_CERTIFICATE, arguments);
}

Future<File> writeFile(Uint8List data, String name) async {
  // storage permission ask
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  // the downloads folder path
  //Directory tempDir = await getApplicationSupportDirectory();
  String tempPath = "";
  if (Platform.isAndroid) {
    tempPath = "/storage/emulated/0/Download";
  } else {
    var tempdir = await getDownloadsDirectory();
    tempPath = tempdir!.path;
  }
  log(tempPath);
  var filePath = tempPath + '/$name';
  //
  // the data
  var bytes = ByteData.view(data.buffer);
  final buffer = bytes.buffer;
  // save the data in the path
  try {
    File pdfFile = await File(filePath).create(recursive: true);

    return pdfFile.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  } catch (e) {
    log(e.toString());
    throw e;
  }
}
