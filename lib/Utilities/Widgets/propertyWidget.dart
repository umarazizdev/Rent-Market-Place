import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Screens/BuyerScreens/HomeScreen/detailscreen.dart';
import '../Colors/color.dart';

class PropertyWidget extends StatelessWidget {
  const PropertyWidget({
    Key? key,
    required Stream<QuerySnapshot<Object?>> homeStream,
  })  : _homeStream = homeStream,
        super(key: key);

  final Stream<QuerySnapshot<Object?>> _homeStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _homeStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
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
                  padding: const EdgeInsets.only(left: 7.0, top: 7),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GetUserName(
                                    documentId: data.id,
                                  )));
                    },
                    child: Container(
                      height: 90,
                      width: 73,
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
                                  fontSize: 8, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 6.9,
                                ),
                                Expanded(
                                  child: Text(
                                    data['location'],
                                    style: const TextStyle(
                                        fontSize: 6.5,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
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
