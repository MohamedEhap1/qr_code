import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code/screens/generate_screen.dart';
import 'package:qr_code/screens/result_scan_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String scanResult = '';
  //create scan function
  Future<void> scanCode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#19A0F5', 'Cancel', true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to Scan';
    }
    if (!mounted) return;
    setState(
      () {
        if (barcodeScanRes != 'Failed to Scan') {
          final player = AudioPlayer();
          player.play(AssetSource('sounds/scanSound.mp3'));
          scanResult = barcodeScanRes;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 4, 85, 9),
        title: const Text(
          'QR Scanner | Generate ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.75,
            width: double.infinity,
            child: const Image(
              image: AssetImage(
                'assets/images/Scan.jpg',
              ),
              fit: BoxFit.contain,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 85, 9),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await scanCode();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ResultScan(
                            result: scanResult,
                          )));
                },
                child: const Text('Scan'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 85, 9),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GenerateQr()));
                },
                child: const Text('Generate QrCode'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
