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
    // 🔹 قراءة الصورة الأصلية من UploadedFile
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 1️⃣ تحويل الصورة إلى Grayscale
    image = img.grayscale(image);

    // 2️⃣ زيادة الـ Contrast والـ Brightness لتحسين وضوح النقاط
    image = img.adjustColor(
      image,
      contrast: 2.0, // contrast عالي لتجميع النقاط الصغيرة
      brightness: 0.05, // تفتيح بسيط للصورة
    );

    // 3️⃣ فلتر Sharpen لتوضيح الحروف الدقيقة المطبوعة
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

    // 4️⃣ Threshold خفيف لزيادة الفرق بين الخلفية والنص
    const thresholdValue = 150;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final luma = img.getLuminance(pixel);
        final value = luma < thresholdValue ? 0 : 255;
        image.setPixelRgba(x, y, value, value, value, 255);
      }
    }

    // 5️⃣ حفظ الصورة الناتجة مؤقتًا
    final tempDir = await getTemporaryDirectory();
    final processedPath =
        '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final processedFile = File(processedPath);
    await processedFile.writeAsBytes(img.encodeJpg(image, quality: 95));

    // 6️⃣ قراءة الصورة الناتجة وإرجاعها كـ UploadedFile
    final processedBytes = await processedFile.readAsBytes();
    return FFUploadedFile(
      name: imageFile.name != null
          ? 'processed_${imageFile.name}'
          : 'processed.jpg',
      bytes: processedBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile; // fallback: نرجع الأصل لو حصل خطأ
  }
}
