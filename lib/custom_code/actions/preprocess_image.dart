// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<FFUploadedFile> preprocessImage(FFUploadedFile imageFile) async {
  try {
    // 🟢 قراءة الصورة الأصلية
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 1️⃣ تحويل إلى Grayscale
    image = img.grayscale(image);

    // 2️⃣ Sharpen بسيط (بدون تحويل قوي)
    final sharpenKernel = [
      0,
      -1,
      0,
      -1,
      4,
      -1,
      0,
      -1,
      0,
    ];

    image = img.convolution(
      image,
      filter: sharpenKernel,
      div: 1.0,
      offset: 128, // ✅ نضيف Offset بسيط علشان الصورة متسودش
      maskChannel: img.Channel.luminance,
    );

    // 3️⃣ Contrast و Brightness معتدلين
    image = img.adjustColor(
      image,
      contrast: 1.5, // أقل من 2.0 علشان ميولعش
      brightness: 0.1, // تفتيح خفيف
    );

    // ❌ مفيش Threshold هنا علشان متطلعش سودا

    // 4️⃣ حفظ الصورة الناتجة مؤقتًا
    final tempDir = await getTemporaryDirectory();
    final processedPath =
        '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final processedFile = File(processedPath);
    await processedFile.writeAsBytes(img.encodeJpg(image, quality: 95));

    // 5️⃣ إرجاع الصورة كـ FFUploadedFile
    final processedBytes = await processedFile.readAsBytes();
    return FFUploadedFile(
      name: imageFile.name != null
          ? 'processed_${imageFile.name}'
          : 'processed.jpg',
      bytes: processedBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile; // fallback لو حصل خطأ
  }
}
