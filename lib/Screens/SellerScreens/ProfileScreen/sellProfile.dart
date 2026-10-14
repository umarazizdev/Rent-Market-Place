import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/SellerScreens/SellingScreen/sellingscreeen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Supabase/supabase_storage_service.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class SellProfile extends StatefulWidget {
  const SellProfile({super.key});
  @override
  State<SellProfile> createState() => _SellProfileState();
}

class _SellProfileState extends State<SellProfile> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();
  final _formKey = GlobalKey<FormState>();
  var name = TextEditingController();
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  XFile? singleImage;

  chooseImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<String> uploadImage(XFile? image, String oldName, String oldAvatar) async {
    try {
      String avatarUrl = oldAvatar;
      if (image != null) {
        avatarUrl = await SupabaseStorageService.uploadImage(image, folder: 'avatars');
      }
      String finalName = name.text.trim().isEmpty ? oldName : name.text.trim();

      await user.doc(box.read('uid')).set({
        'avatar': avatarUrl,
        'name': finalName,
        'uid': box.read('uid'),
        'image': true,
      }, SetOptions(merge: true)); // FIX: merge true

      EasyLoading.showSuccess("Successfully Updated");
      return avatarUrl;
    } catch (error) {
      EasyLoading.dismiss();
      EasyLoading.showError('Update failed');
      print("failedtoadduser: $error");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: primaryClr));
        }
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text("No user found"));

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index];
            // auto fill controller first time
            if (name.text.isEmpty) name.text = data['name'] ?? '';
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () async {
                          singleImage = await chooseImage();
                          if (singleImage != null) setState(() {});
                        },
                        child: Center(
                          child: Container(
                            height: 115, width: 115,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
                            child: singleImage != null
                                ? ClipRRect(borderRadius: BorderRadius.circular(60), child: Image.file(File(singleImage!.path), height: 115, width: 115, fit: BoxFit.cover))
                                : Stack(children: [
                                    SafeAvatar(url: data['avatar']?.toString(), radius: 55),
                                    Positioned(bottom: 0, right: 0, child: Container(height: 25, width: 25, decoration: BoxDecoration(color: primaryClr.withOpacity(0.6), shape: BoxShape.circle), child: Icon(Icons.edit, color: blackclr.withOpacity(0.6), size: 20))),
                                  ]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Name", style: TextStyle(color: blackclr, fontWeight: FontWeight.w500)),
                      TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          hintText: data['name'],
                          labelStyle: TextStyle(color: blackclr.withOpacity(0.6)),
                          suffixIcon: const Icon(Icons.edit, size: 20),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text("Uid", style: TextStyle(color: blackclr, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      Padding(padding: const EdgeInsets.only(left: 12.0), child: Text(data['uid'], style: TextStyle(color: blackclr.withOpacity(0.6), fontSize: 14))),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 52, width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              EasyLoading.show();
                              uploadImage(singleImage, data['name'] ?? '', data['avatar'] ?? '');
                            }
                          },
                          child: const Text('Update Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 52, width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellingScreen())),
                          child: const Text('Add Products', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}