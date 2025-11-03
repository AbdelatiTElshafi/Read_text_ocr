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
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 1️⃣ Grayscale
    image = img.grayscale(image);

    // 2️⃣ Normalize القيم بين 60 و230 (نمنع الحرق)
    int minL = 255, maxL = 0;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final l = img.getLuminance(image.getPixel(x, y)).toInt();
        if (l < minL) minL = l;
        if (l > maxL) maxL = l;
      }
    }
    final range = (maxL - minL).clamp(1, 255);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final l = img.getLuminance(image.getPixel(x, y)).toInt();
        int norm = (((l - minL) * 170) ~/ range) + 60; // normalize 60–230
        norm = norm.clamp(0, 255);
        image.setPixelRgba(x, y, norm, norm, norm, 255);
      }
    }

    // 3️⃣ Contrast خفيف جدًا
    image = img.adjustColor(image, contrast: 1.1, brightness: 0.05);

    // 4️⃣ Sharpen بسيط مع offset لتجنب السواد
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
      div: 3.0, // نخفف قوة الفلتر
      offset: 64, // نرفع الإضاءة عشان ميحرقش
      maskChannel: img.Channel.luminance,
    );

    // 5️⃣ نرجّع الصورة الرمادية الجديدة
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: 'normalized_${imageFile.name ?? "image.jpg"}',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile;
  }
}
