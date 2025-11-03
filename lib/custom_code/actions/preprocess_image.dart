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
    // 1️⃣ قراءة الصورة
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image data');

    // 2️⃣ تحويل إلى رمادي (Grayscale)
    image = img.grayscale(image);
    image = img.adjustColor(image, saturation: 0); // تأكيد إزالة أي لون متبقي

    // 3️⃣ Sharpen بسيط باستخدام convolution (الطريقة الصحيحة في image 4.x)
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

    // 4️⃣ رفع Contrast وBrightness خفيفين لتحسين الوضوح
    image = img.adjustColor(image,
        contrast: 1.3, // معتدل جدًا
        brightness: 0.05 // تفتيح بسيط
        );

    // 5️⃣ إرجاع الصورة النهائية كـ UploadedFile
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: imageFile.name != null
          ? 'processed_${imageFile.name}'
          : 'processed.jpg',
      bytes: outBytes,
    );
  } catch (e) {
    print('Error preprocessing image: $e');
    return imageFile;
  }
}
