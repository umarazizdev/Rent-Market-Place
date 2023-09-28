import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/HomeScreen/detailscreen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final bool location;

  const CategoryWidget({
    super.key,
    required Stream<QuerySnapshot<Object?>> stream,
    required this.location,
  }) : _usersStream = stream;

  final Stream<QuerySnapshot<Object?>> _usersStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            strokeWidth: 3,
            color: primaryClr,
          );
        }

        return SizedBox(
          height: 103,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 7.0, right: 7, top: 7),
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
                      height: 91,
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
                              height: 39,
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
                              height: 8,
                            ),
                            if (!location)
                              const SizedBox(
                                height: 10,
                              ),
                            Text(
                              data['title'].toString(),
                              style: const TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            if (location)
                              Expanded(
                                child: Text(
                                  data['location'],
                                  style: const TextStyle(
                                      fontSize: 7, fontWeight: FontWeight.w500),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
