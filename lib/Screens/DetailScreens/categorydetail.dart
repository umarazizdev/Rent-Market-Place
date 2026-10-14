import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/HomeScreen/detailscreen.dart';
import 'package:figma2/Utilities/Widgets/product_image_replace_button.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../Models/Logos/logosmodel.dart';
import '../../Utilities/Colors/color.dart';

class CarScreen extends StatefulWidget {
  final Logos details;
  const CarScreen({super.key, required this.details});

  @override
  State<CarScreen> createState() => _CarScreenState();
}
// category screen
class _CarScreenState extends State<CarScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('products')
        .where('Category', isEqualTo: widget.details.name)
        .snapshots();
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      widget.details.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: 1.5,
                      width: 50,
                      color: Colors.black,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
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
                        final currentUid = box.read('uid')?.toString();
                        final isOwner = currentUid != null &&
                            currentUid.isNotEmpty &&
                            currentUid == data['uid']?.toString();

                        return Container(
                          height: 190,
                          width: 155,
                          decoration: BoxDecoration(
                            border: Border.all(color: blackclr),
                            borderRadius: BorderRadius.circular(4.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GetUserName(documentId: data.id),
                                      ));
                                },
                                child: Stack(
                                  children: [
                                    SafeNetworkImage(
                                      url: data['image']?.toString(),
                                      height: 118,
                                      width: double.infinity,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.5),
                                        topRight: Radius.circular(4.5),
                                      ),
                                    ),
                                    if (isOwner)
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: ProductImageReplaceButton(
                                          productId: data.id,
                                        ),
                                      ),
                                  ],
                                ),
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
                                        data['location']?.toString() ?? '',
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
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 9,
                                                color: blackclr,
                                                fontWeight: FontWeight.w700,
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
                        );
                      }),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
