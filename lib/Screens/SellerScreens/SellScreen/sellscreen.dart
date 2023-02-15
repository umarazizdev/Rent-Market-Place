import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Models/Logos/logosmodel.dart';
import 'package:figma2/Screens/DetailScreens/categorydetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../Utilities/Colors/color.dart';
import '../../BuyerScreens/HomeScreen/detailscreen.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('products').snapshots();

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
                              height: 180,
                              width: 155,
                              decoration: BoxDecoration(
                                border: Border.all(color: blackclr),
                                borderRadius: BorderRadius.circular(4.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7.0),
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
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          ),
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
