import 'package:flutter/material.dart';
import 'package:qr_code/screens/scanner_screen.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScannerScreen(),
    );
  }
}
