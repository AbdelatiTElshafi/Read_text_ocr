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

    // 2️⃣ تحويل للصورة الرمادية (Grayscale)
    image = img.grayscale(image);
    image = img.adjustColor(image, saturation: 0); // تأكيد إزالة أي لون

    // 3️⃣ تعديل Contrast و Brightness خفيفين لتحسين النصوص
    image = img.adjustColor(image,
        contrast: 1.3, // تباين متوسط
        brightness: 0.05 // تفتيح بسيط
        );

    // 4️⃣ Erode يدوي (لتوصيل نقاط CIJ وتقوية الحروف)
    final copy = img.copyCrop(
      image,
      x: 0,
      y: 0,
      width: image.width,
      height: image.height,
    );

    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        int minLuma = 255;
        // نقرأ مربع 3×3 حول كل بكسل
        for (int j = -1; j <= 1; j++) {
          for (int i = -1; i <= 1; i++) {
            final luma = img.getLuminance(copy.getPixel(x + i, y + j)).toInt();
            if (luma < minLuma) minLuma = luma;
          }
        }
        image.setPixelRgba(x, y, minLuma, minLuma, minLuma, 255);
      }
    }

    // 5️⃣ تحويل الصورة الناتجة إلى بايتات وإرجاعها
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: imageFile.name != null ? 'eroded_${imageFile.name}' : 'eroded.jpg',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile;
  }
}
