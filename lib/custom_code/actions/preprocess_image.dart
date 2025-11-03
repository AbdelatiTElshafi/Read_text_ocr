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
    // 1) قراءة الصورة من الـ UploadedFile
    final bytes = imageFile.bytes!;
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Invalid image data');
    }

    // 2) تحويل للصورة الرمادية فقط (Grayscale)
    image = img.grayscale(image);

    // 3) ترميز الصورة وارجاعها كـ UploadedFile (بدون حفظ ملفات مؤقتة)
    final outBytes = img.encodeJpg(image, quality: 95);
    return FFUploadedFile(
      name: imageFile.name != null
          ? 'grayscale_${imageFile.name}'
          : 'grayscale.jpg',
      bytes: outBytes,
    );
  } catch (e) {
    print('Grayscale error: $e');
    // لو حصل خطأ رجّع الصورة الأصلية
    return imageFile;
  }
}
