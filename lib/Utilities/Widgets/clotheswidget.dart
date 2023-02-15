import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';

import '../../Screens/BuyerScreens/HomeScreen/detailscreen.dart';

class ClothesWidget extends StatelessWidget {
  const ClothesWidget({
    Key? key,
    required Stream<QuerySnapshot<Object?>> clothesStream,
  })  : _clothesStream = clothesStream,
        super(key: key);

  final Stream<QuerySnapshot<Object?>> _clothesStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _clothesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              strokeWidth: 3,
              color: primaryClr,
            );
          }

          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetUserName(
                            documentId: data.id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 90,
                      width: 69,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff928D8D)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(data['image']),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              data['title'].toString(),
                              style: const TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
