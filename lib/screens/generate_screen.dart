import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code/shared/custom_snackBar_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class GenerateQr extends StatefulWidget {
  const GenerateQr({super.key});

  @override
  State<GenerateQr> createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  final TextEditingController _textController = TextEditingController(text: '');
  String data = '';
  final GlobalKey _qrkey = GlobalKey();
  bool dirExists = false;
  dynamic externalDir = '/storage/emulated/0/Download/Qr Code Generator';
  Future<void> _captureAndSavepng() async {
    try {
// RenderRepaintBoundary acts as a boundary that captures and caches the visual output of a widget subtree.
// It enables the code to obtain an image representation of the QR code widget,
//which can be used for various purposes such as saving, sharing, or displaying the QR code image.
      RenderRepaintBoundary boundary =
          _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
// converted to an image using the toImage() method, with a pixelRatio of 3.0 specified to increase the image's resolution
// A higher value for pixelRatio results in a sharper and higher-quality image.
      var image = await boundary.toImage(pixelRatio: 3.0);

      //Drawing White Background because Qr Code is Black
      final whitePaint = Paint()..color = Colors.white; //background of image
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      //Check for duplicate file name to avoid Override
      String fileName = 'qr_code';
      int i = 1;
      while (await File('$externalDir/$fileName.png').exists()) {
        //check non repeated the name of image
        fileName = 'qr_code_$i';
        i++;
      }

      // Check if Directory Path exists or not
      dirExists = await File(externalDir).exists();
      //if not then create the path
      if (!dirExists) {
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      showSnackBar(context, 'QR code saved to gallery');
    } catch (e) {
      log(e.toString());
      if (!mounted) return;
      showSnackBar(context, 'Something went wrong!!!');
    }
  }

  //share qrcode method
  Future<void> _shareQrcode() async {
    try {
      RenderRepaintBoundary boundary =
          _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);

      //Drawing White Background because Qr Code is Black
      final whitePaint = Paint()..color = Colors.white; //background of image
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image to a temporary file
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File tempFile = File('$tempPath/qr_code.png');
      await tempFile.writeAsBytes(pngBytes);

      // Share the image using the share_plus package
      await Share.shareFiles([tempFile.path]);
    } catch (e) {
      showSnackBar(context, 'Something went wrong!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 4, 85, 9),
        title: const Text('QR Code Generator'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 4, 85, 9),
        onPressed: _shareQrcode,
        child: const Icon(
          Icons.share,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                prefix: Icon(Icons.link),
                hintText: "Enter your url here...",
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                data = _textController.text;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 4, 85, 9),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Generate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: RepaintBoundary(
              key: _qrkey,
              child: QrImageView(
                // ignore: deprecated_member_use
                foregroundColor: const Color.fromARGB(255, 4, 85, 9),
                // dataModuleStyle: const QrDataModuleStyle(
                //     dataModuleShape: QrDataModuleShape.square,
                //     color: Color.fromARGB(255, 4, 85, 9)),
                //this function in qr flutter package
                data: data,
                version: QrVersions.auto,
                size: MediaQuery.sizeOf(context).height * 0.4,
                gapless: true,
                errorStateBuilder: (ctx, err) {
                  return const Center(
                    child: Text(
                      'Something went wrong!!!',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: _captureAndSavepng,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 4, 85, 9),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Save image',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
//1- Capture the Widget as an Image:
// First, wrap the widget you want to capture in a RepaintBoundary. This widget creates a separate display list for its child.
// Provide a GlobalKey to the RepaintBoundary.
// For example:
// Dart

// GlobalKey globalKey = GlobalKey();
// RepaintBoundary(
//   key: globalKey,
//   child: YourCustomWidget(),
// )

//2- Capture the Image:
// Use the toImage method of the RepaintBoundary to capture the image for the current state of the widget.
// Convert the captured image to bytes in png format using image.toByteData(format: ui.ImageByteFormat.png).

//3- Save the Image:
// Save the image to a file or stream it to a server.
// You can use the screenshot package to capture a widget that isn’t displayed on screen. It provides a convenient way to save the widget directly as an image.
// Example using the screenshot package
