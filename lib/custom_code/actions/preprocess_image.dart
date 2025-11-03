// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:image/image.dart' as img;

Future<FFUploadedFile> preprocessImage(FFUploadedFile imageFile) async {
  try {
    // 1️⃣ قراءة الصورة
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 2️⃣ تحويل للصورة الرمادية (Grayscale)
    image = img.grayscale(image);

    // 3️⃣ تعديل Contrast و Brightness
    image = img.adjustColor(
      image,
      contrast: 1.4, // زيادة وضوح التباين بين الحروف والخلفية
      brightness: 0.1, // تفتيح بسيط
    );

    // 4️⃣ تحويل الصورة لبايتات وإرجاعها
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: imageFile.name != null
          ? 'gray_contrast_${imageFile.name}'
          : 'gray_contrast.jpg',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile;
  }
}
