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

    // 2️⃣ تحويل للصورة الرمادية فقط
    image = img.grayscale(image);

    // 3️⃣ زيادة الـ Contrast بنسبة خفيفة (1.3 = +30%)
    image = img.adjustColor(
      image,
      contrast: 1.3, // جرب تغيّرها لـ 1.5 لو لسه الصورة باهتة
    );

    // 4️⃣ ترميز الصورة وإرجاعها
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: 'grayscale_contrast_${imageFile.name ?? "image.jpg"}',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile;
  }
}
