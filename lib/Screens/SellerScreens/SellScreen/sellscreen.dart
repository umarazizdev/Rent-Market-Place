import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Models/Logos/logosmodel.dart';
import 'package:figma2/Screens/DetailScreens/categorydetail.dart';
import 'package:figma2/Utilities/Supabase/supabase_storage_service.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utilities/Colors/color.dart';
import '../../BuyerScreens/HomeScreen/detailscreen.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  late final Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    final uid = box.read('uid');
    _usersStream = uid == null || uid.toString().isEmpty
        ? FirebaseFirestore.instance.collection('products').snapshots()
        : FirebaseFirestore.instance
            .collection('products')
            .where('uid', isEqualTo: uid)
            .snapshots();
  }

  Future<void> _updateProductImage(String productId) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    EasyLoading.show(status: 'Updating image...');
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
    } catch (e) {
      EasyLoading.showError('Image update failed');
      print('update image failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var searchcontroller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30),
                child: SizedBox(
                  height: 30,
                  child: TextFormField(
                    controller: searchcontroller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.location_on,
                        color: Color(0xff434343),
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 32),
                      hintText: "New York City Usa",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: Color(0xff554F4F),
                      ),
                      filled: true,
                      fillColor: const Color(0xffD9D9D9),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30),
                child: SizedBox(
                  height: 30,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search_outlined,
                        color: Color(0xff434343),
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 32),
                      hintText: "Find Cars Property And More",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: Color(0xff554F4F),
                      ),
                      filled: true,
                      fillColor: const Color(0xffD9D9D9),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: SizedBox(
                  height: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: logoslist.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CarScreen(details: logoslist[index])));
                        },
                        child: Container(
                          height: 40,
                          width: 42,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffD9D9D9),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  logoslist[index].image,
                                  height: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    logoslist[index].name,
                                    style: const TextStyle(
                                        fontSize: 7,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tap the camera icon to update product image only',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xff7D756C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: primaryClr,
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('No products found for your account'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 20),
                    child: AlignedGridView.count(
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 25,
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          final imageUrl = (data.data()
                                  as Map<String, dynamic>)['image']
                              ?.toString();

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GetUserName(
                                            documentId: data.id,
                                          )));
                            },
                            child: Container(
                              height: 190,
                              width: 155,
                              decoration: BoxDecoration(
                                border: Border.all(color: blackclr),
                                borderRadius: BorderRadius.circular(4.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      SafeNetworkImage(
                                        url: imageUrl,
                                        height: 118,
                                        width: double.infinity,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.5),
                                          topRight: Radius.circular(4.5),
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Material(
                                          color: primaryClr,
                                          shape: const CircleBorder(),
                                          child: InkWell(
                                            customBorder:
                                                const CircleBorder(),
                                            onTap: () =>
                                                _updateProductImage(data.id),
                                            child: const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Icon(
                                                Icons.photo_camera,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 4.0, 7.0, 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['title']?.toString() ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            data['location']?.toString() ??
                                                '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xff7D756C),
                                              fontSize: 9,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '${data['price']}/Week only',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    color: blackclr,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.favorite_border,
                                                color: Color(0xffB7B7B7),
                                                size: 11,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
