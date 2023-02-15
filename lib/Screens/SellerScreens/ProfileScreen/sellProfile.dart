import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/SellerScreens/SellingScreen/sellingscreeen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  // final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
  //     .collection('products')
  //     .snapshots();

  final _formKey = GlobalKey<FormState>();
  var name = TextEditingController();
  var lastname = TextEditingController();

  CollectionReference user = FirebaseFirestore.instance.collection('users');
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  XFile? singleImage;
  chooseImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

///////////////
  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

//upload data
  Future<String> uploadImage(XFile image) async {
    Reference db = FirebaseStorage.instance.ref("image/${getImageName(image)}");

    await db.putFile(File(image.path));
    return await db.getDownloadURL().then((value) async {
      user
          .doc(box.read('uid'))
          .set({
            'avatar': value,
            'image': true,
            'name': name.text,
            'uid': box.read('uid')
          })
          .then((value) => print('Product Edited'))
          .whenComplete(() => EasyLoading.showSuccess("Successfully Added"))
          .catchError((error) => print("failedtoadduser: $error"));

      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
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
                      const SizedBox(height: 30),
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
                                        Image.network(
                                            "https://www.lightsong.net/wp-content/uploads/2020/12/blank-profile-circle.png"),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
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
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                          // contentPadding:
                          //     const EdgeInsets.only(left: 33, top: 22, bottom: 18),
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
                        height: 40,
                      ),
                      Center(
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                EasyLoading.show();
                                uploadImage(singleImage!);
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
                        height: 25,
                      ),
                      Center(
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SellingScreen(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Add Products',
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
