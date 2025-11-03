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
    // 1️⃣ نقرأ الصورة الأصلية
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 2️⃣ نحول الصورة إلى رمادي
    image = img.grayscale(image);

    // 3️⃣ نزود الـ contrast بقيمة 3 زي ما ظبطت حضرتك
    image = img.adjustColor(
      image,
      contrast: 3.0,
    );

    // 4️⃣ نطبق Threshold بسيط (قيمة 128 في النص)
    // لو عايز تغمق أكتر جرب تخليها 140 أو 160
    const threshold = 128;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int luma = img.getLuminance(image.getPixel(x, y)).toInt();
        int value = luma < threshold ? 0 : 255;
        image.setPixelRgba(x, y, value, value, value, 255);
      }
    }

    // 5️⃣ نحول الصورة لبايتات ونرجعها
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: 'threshold_${imageFile.name ?? "image.jpg"}',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile;
  }
}
