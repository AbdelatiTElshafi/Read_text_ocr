// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:image/image.dart' as img;
import 'dart:math';

Future<FFUploadedFile> preprocessImage(FFUploadedFile imageFile) async {
  try {
    // 1️⃣ قراءة الصورة الأصلية
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 2️⃣ تحويلها إلى رمادي
    image = img.grayscale(image);

    // 3️⃣ زيادة التباين زي ما ظبطتها حضرتك
    image = img.adjustColor(
      image,
      contrast: 3.0,
    );

    // 4️⃣ تطبيق Adaptive Threshold
    //    blockSize = حجم المنطقة (يفضل فردي)
    //    offset = رقم يُطرح من المتوسط (بيحدد شدة العتبة)
    const int blockSize = 15;
    const int offset = 10;

    final copy = img.copyResize(image); // نسخة للقراءة
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int sum = 0;
        int count = 0;

        // حساب المتوسط في مربع محلي حول البكسل
        for (int j = -blockSize ~/ 2; j <= blockSize ~/ 2; j++) {
          for (int i = -blockSize ~/ 2; i <= blockSize ~/ 2; i++) {
            int xx = (x + i).clamp(0, image.width - 1);
            int yy = (y + j).clamp(0, image.height - 1);
            sum += img.getLuminance(copy.getPixel(xx, yy)).toInt();
            count++;
          }
        }

        int localMean = sum ~/ count;
        int luma = img.getLuminance(copy.getPixel(x, y)).toInt();
        int value = luma < (localMean - offset) ? 0 : 255;
        image.setPixelRgba(x, y, value, value, value, 255);
      }
    }

    // 5️⃣ تحويلها إلى UploadedFile
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: 'adaptive_${imageFile.name ?? "image.jpg"}',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error in adaptive threshold: $e');
    return imageFile;
  }
}
