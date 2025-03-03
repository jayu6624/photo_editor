// lib/screens/save_page.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';

class SavePage extends StatelessWidget {
  final Uint8List editedImageBytes;

  const SavePage({Key? key, required this.editedImageBytes, required String editedImagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Save Image')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showMessage(context),
          child: const Text('Download Image (Coming Soon)'),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image download feature is temporarily disabled.')),
    );
  }
}
