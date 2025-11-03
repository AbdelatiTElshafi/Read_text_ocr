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
    // 1️⃣ قراءة الصورة الأصلية
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 2️⃣ تحويل للصورة الرمادية
    image = img.grayscale(image);

    // 3️⃣ زيادة التباين
    image = img.adjustColor(
      image,
      contrast: 3.0, // جرب 2.5 لو الصورة غامقة قوي
    );

    // 4️⃣ إرجاع الصورة الرمادية المعالجة
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: 'gray_contrast_${imageFile.name ?? "image.jpg"}',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error in grayscale+contrast preprocess: $e');
    return imageFile;
  }
}
