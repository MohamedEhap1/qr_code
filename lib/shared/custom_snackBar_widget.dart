import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(days: 1),
      content: const Text('QR code saved to gallery'),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    ),
  );
}
