import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/HomeScreen/detailscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../Models/Logos/logosmodel.dart';
import '../../Utilities/Colors/color.dart';
import '../../main.dart';

class CarScreen extends StatefulWidget {
  final Logos details;
  const CarScreen({super.key, required this.details});

  @override
  State<CarScreen> createState() => _CarScreenState();
}

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

                        return Container(
                          height: 180,
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
                                child: Container(
                                  height: 123,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(data['image'])),
                                    color: blackclr,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.5),
                                        topRight: Radius.circular(4.5)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      data['title'],
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      data['location'],
                                      style: const TextStyle(
                                          color: Color(0xff7D756C),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: data['price'],
                                          style: const TextStyle(
                                              fontSize: 9,
                                              color: blackclr,
                                              fontWeight: FontWeight.w700),
                                          children: const [
                                            TextSpan(
                                              text: "/Week only",
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: blackclr,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          ]),
                                    ),
                                    const Icon(
                                      Icons.favorite_border,
                                      color: Color(0xffB7B7B7),
                                      size: 11,
                                    ),
                                  ],
                                ),
                              )
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
