import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<dynamic>> pickImages() async {
  List<dynamic> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
      allowCompression: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        if (kIsWeb) {
          images.add(files.files[i].bytes!);
        } else {
          images.add(File(files.files[i].path!));
        }
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

Future<dynamic> pickImage() async {
  try {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
      allowCompression: true,
    );
    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        return result.files.first.bytes!;
      } else {
        return File(result.files.first.path!);
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}