import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Supabase/supabase_storage_service.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();

  final _formKey = GlobalKey<FormState>();
  var name = TextEditingController();
  var lastname = TextEditingController();

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
    }, SetOptions(merge: true));
    EasyLoading.showSuccess("Successfully Updated");
    return avatarUrl;
  } catch (error) {
    EasyLoading.dismiss();
    EasyLoading.showError('Update failed');
    print("failed: $error");
    return '';
  }
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index];
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 65),
                      InkWell(
                        onTap: () async {
                          singleImage = await chooseImage();
                          if (singleImage != null &&
                              singleImage!.path.isNotEmpty) {
                            setState(() {});
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 115,
                            width: 115,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: singleImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        File(singleImage!.path),
                                        height: 115,
                                        width: 115,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        SafeAvatar(
                                          url: data['avatar']?.toString(),
                                          radius: 55,
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    color: primaryClr
                                                        .withOpacity(0.6),
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.edit,
                                                  color:
                                                      blackclr.withOpacity(0.6),
                                                  size: 20,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Name",
                        style: TextStyle(
                            color: blackclr, fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: data['name'],
                          labelStyle:
                              TextStyle(color: blackclr.withOpacity(0.6)),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          suffixIcon: const Icon(
                            Icons.edit,
                            size: 20,
                          ),
                          hintStyle: const TextStyle(
                            color: textClr,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Divider(
                          thickness: 1,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      /*
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Last Name",
                        style: TextStyle(
                            color: blackclr, fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: lastname,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          hintStyle: const TextStyle(
                            color: textClr,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Divider(
                          thickness: 1,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      */
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Uid",
                        style: TextStyle(
                            color: blackclr, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          data['uid'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: blackclr.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Divider(
                          thickness: 1,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Center(
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
  if (_formKey.currentState!.validate()) {
    EasyLoading.show();
    uploadImage(singleImage, data['name'] ?? '', data['avatar'] ?? '');
  }
},
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Update Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      )
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
