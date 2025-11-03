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
    // 1) اقرأ الصورة
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 2) إجبارها رمادي بطريقتين (لضمان النتيجة):
    //   - grayscale (يحسِب اللّمينانس)
    //   - saturation=0 (يلغي أي “صبغة” باقيه)
    image = img.grayscale(image);
    image = img.adjustColor(image, saturation: 0);

    // 3) Sharpen خفيف (ب انحياز صفري عشان ما يغمّقش الخلفية)
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

    // 4) Contrast بسيط جدًا + Brightness خفيف
    image = img.adjustColor(image,
        contrast: 1.25, // خفيف
        brightness: 0.05 // خفيف
        );

    // 5) إرجاع الصورة (JPG رمادي – r=g=b)
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: imageFile.name != null ? 'gray_${imageFile.name}' : 'gray.jpg',
      bytes: outBytes,
    );
  } catch (e) {
    print('Preprocess error: $e');
    return imageFile;
  }
}
