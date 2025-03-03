// editor_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'save_page.dart';

class EditorPage extends StatefulWidget {
  final String imagePath;

  const EditorPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _image = File(widget.imagePath);
    }
  }

  Future<void> _openEditor() async {
    setState(() => _isLoading = true);

    try {
      final imageBytes = kIsWeb
          ? await XFile(widget.imagePath).readAsBytes()
          : await _image!.readAsBytes();

      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(image: imageBytes),
        ),
      );

      if (editedImage != null && mounted) {
        final String tempPath = kIsWeb
            ? widget.imagePath // Skip saving for web (just pass bytes)
            : '${_image!.path}_edited';

        File? tempImage;
        if (!kIsWeb) {
          tempImage = await File(tempPath).writeAsBytes(editedImage);
        }

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SavePage(
                editedImagePath: kIsWeb ? tempPath : tempImage!.path,
                editedImageBytes: editedImage,
              ),
            ),
          );
        }
      }
    } catch (e) {
      _showSnackBar('Error editing image: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = kIsWeb
        ? Image.network(widget.imagePath, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100))
        : Image.file(_image!, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100));

    return Scaffold(
      appBar: AppBar(title: const Text('Image Editor')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: Center(child: imageWidget)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _openEditor,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Start Editing', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
    );
  }
}
