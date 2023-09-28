import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Utilities/Colors/color.dart';
import '../../../main.dart';

class SellingScreen extends StatefulWidget {
  const SellingScreen({super.key});
  @override
  State<SellingScreen> createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen> {
  final _formKey = GlobalKey<FormState>();
  var brand = TextEditingController();
  var price = TextEditingController();
  var description = TextEditingController();
  var title = TextEditingController();
  var location = TextEditingController();
  var category = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('products');
  XFile? singleImage;
  chooseImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Future<String> uploadImage(XFile image) async {
    Reference db = FirebaseStorage.instance.ref("image/${getImageName(image)}");

    await db.putFile(File(image.path));
    return await db.getDownloadURL().then((value) async {
      users
          .add({
            'image': value,
            'brand': brand.text,
            'description': description.text,
            'price': price.text,
            'title': title.text,
            'location': location.text,
            "Category": selectCategory,
            'star1': 0,
            'star2': 0,
            'star3': 0,
            'star4': 0,
            'star5': 0,
            'publish': false,
            'uid': box.read('uid')
          })
          .then((value) => print('Product Edited'))
          .whenComplete(() => EasyLoading.showSuccess("Successfully Added"))
          .catchError((error) => print("failedtoadduser: $error"));

      return '';
    });
  }

  bool isopen = false;
  String selectCategory = 'Select Category';
  List<String> categories = [
    'Car',
    'Home',
    'Furniture',
    'Books',
    'Clothes',
    'Services',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const Center(
                    child: Text(
                      "Selling",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () async {
                      singleImage = await chooseImage();
                      if (singleImage != null && singleImage!.path.isNotEmpty) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primaryClr,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: singleImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(singleImage!.path),
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.camera_enhance,
                                    color: wbackgroundclr,
                                  ),
                                  Text(
                                    "  Add Images",
                                    style: TextStyle(
                                        color: gbackgroundClr,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Brand",
                          style: TextStyle(
                            color: blackclr,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: primaryClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xffC2BDBD),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        controller: brand,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product brand';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Prices",
                          style: TextStyle(
                            color: blackclr,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: primaryClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xffC2BDBD),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        controller: price,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Condition",
                          style: TextStyle(
                            color: blackclr,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: primaryClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 28,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xffC2BDBD),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "New",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff868383)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 28,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xffC2BDBD),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Used",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff868383)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 28,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xffC2BDBD),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Open Box",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff868383)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 28,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xffC2BDBD),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Refreshed",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff868383)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Add Title",
                          style: TextStyle(
                            color: blackclr,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: primaryClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xffC2BDBD),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        controller: title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product title';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Category",
                          style: TextStyle(
                            color: blackclr,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: primaryClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            isopen = !isopen;
                            setState(() {});
                          },
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xffC2BDBD),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectCategory,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Icon(
                                    isopen
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isopen)
                          ListView(
                            shrinkWrap: true,
                            primary: true,
                            children: categories
                                .map((e) => Container(
                                      decoration: BoxDecoration(
                                        color: selectCategory == e
                                            ? Colors.grey
                                            : Colors.grey.shade300,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 6),
                                        child: InkWell(
                                          onTap: () {
                                            selectCategory = e;
                                            isopen = false;
                                            setState(() {});
                                          },
                                          child: Text(
                                            e,
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Description",
                          style: TextStyle(
                            color: blackclr,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: primaryClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xffC2BDBD),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        controller: description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product description';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Location",
                          style: TextStyle(
                            color: blackclr,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: primaryClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xffC2BDBD),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        controller: location,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product location';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        EasyLoading.show();
                        uploadImage(singleImage!);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primaryClr,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "Add Product",
                          style: TextStyle(
                            color: whiteclr,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
