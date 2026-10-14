import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Supabase/supabase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

/// Picks an image, uploads it to Supabase Storage, and updates the
/// Firestore product `image` field with the public URL.
class ProductImageReplaceButton extends StatelessWidget {
  final String productId;
  final bool compact;
  final String? label;

  const ProductImageReplaceButton({
    super.key,
    required this.productId,
    this.compact = true,
    this.label,
  });

  static Future<bool> replaceImage(String productId) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return false;

    EasyLoading.show(status: 'Uploading to Supabase...');
    try {
      final url = await SupabaseStorageService.uploadImage(
        picked,
        folder: 'products',
      );
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'image': url});
      EasyLoading.showSuccess('Image updated');
      return true;
    } catch (e) {
      EasyLoading.showError('Image update failed');
      // ignore: avoid_print
      print('update image failed: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Material(
        color: primaryClr,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => replaceImage(productId),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.photo_camera,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => replaceImage(productId),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryClr,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const Icon(Icons.upload, size: 18),
      label: Text(label ?? 'Upload / Replace image'),
    );
  }
}
