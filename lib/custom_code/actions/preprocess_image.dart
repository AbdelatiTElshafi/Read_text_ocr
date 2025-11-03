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

    // 3️⃣ فلتر Sharpen خفيف لتجميع النقاط المنقطة (CIJ)
    final sharpenKernel = [
      0,
      -1,
      0,
      -1,
      5,
      -1,
      0,
      -1,
      0,
    ];
    image = img.convolution(
      image,
      filter: sharpenKernel,
      div: 1.0,
      offset: 0,
      maskChannel: img.Channel.luminance,
    );

    // 4️⃣ ضبط Contrast وBrightness
    image = img.adjustColor(
      image,
      contrast: 1.4, // تباين متوسط
      brightness: 0.1, // تفتيح خفيف
    );

    // 5️⃣ Erode يدوي (توصيل النقاط الصغيرة وتقوية الحروف)
    final copy = img.copyResize(image); // ننسخ الصورة لقراءتها
    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        int minLuma = 255;
        // نقرأ 3x3 جيران
        for (int j = -1; j <= 1; j++) {
          for (int i = -1; i <= 1; i++) {
            final luma = img.getLuminance(copy.getPixel(x + i, y + j)).toInt();
            if (luma < minLuma) minLuma = luma;
          }
        }
        image.setPixelRgba(x, y, minLuma, minLuma, minLuma, 255);
      }
    }

    // 6️⃣ تحويل الصورة النهائية لبايتات وإرجاعها كـ UploadedFile
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: imageFile.name != null
          ? 'enhanced_${imageFile.name}'
          : 'enhanced.jpg',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile; // fallback في حالة الخطأ
  }
}
