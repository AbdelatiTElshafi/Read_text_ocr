// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> readTextFromImage(FFUploadedFile imageFile) async {
  try {
    // ✅ نحفظ الصورة مؤقتًا من UploadedFile bytes
    final bytes = imageFile.bytes!;
    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/ocr_temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    // ✅ نجهز الصورة كـ InputImage
    final inputImage = InputImage.fromFilePath(filePath);

    // ✅ نستخدم TextRecognizer (Latin افتراضي – يناسب الإنجليزية والأرقام)
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    // ✅ نحلل الصورة
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    await textRecognizer.close();

    // ✅ نرجّع النص المقروء بالكامل
    return recognizedText.text.isNotEmpty
        ? recognizedText.text
        : 'No text detected';
  } catch (e) {
    print('OCR Error: $e');
    return 'Error reading text: $e';
  }
}
