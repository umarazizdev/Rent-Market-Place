import 'dart:io';

import 'package:figma2/Utilities/Supabase/supabase_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  SupabaseStorageService._();

  static final _client = Supabase.instance.client;

  /// Uploads [image] under `rent-market/[folder]/` and returns the public URL.
  static Future<String> uploadImage(
    XFile image, {
    String folder = 'images',
  }) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    final path = '${SupabaseConfig.appFolder}/$folder/$fileName';
    final contentType = _contentTypeFor(image.name);

    await _client.storage.from(SupabaseConfig.bucket).upload(
          path,
          File(image.path),
          fileOptions: FileOptions(
            upsert: true,
            contentType: contentType,
          ),
        );

    return _client.storage.from(SupabaseConfig.bucket).getPublicUrl(path);
  }

  static String _contentTypeFor(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }
}
