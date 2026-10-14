import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/HomeScreen/detailscreen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Widgets/product_image_replace_button.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
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
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index];
              final currentUid = box.read('uid')?.toString();
              final isOwner = currentUid != null &&
                  currentUid.isNotEmpty &&
                  currentUid == data['uid']?.toString();
              return Padding(
                padding: const EdgeInsets.only(left: 7.0, right: 7, top: 7),
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
                    height: 96,
                    width: 69,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff928D8D)),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SafeNetworkImage(
                              url: data['image']?.toString(),
                              height: 36,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(2),
                              placeholder: Container(
                                color: const Color(0xffD9D9D9),
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 16,
                                  color: Color(0xff928D8D),
                                ),
                              ),
                            ),
                            if (isOwner)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => ProductImageReplaceButton
                                      .replaceImage(data.id),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: primaryClr,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.photo_camera,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'].toString(),
                                maxLines: location ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w300,
                                  height: 1.2,
                                ),
                              ),
                              if (location) ...[
                                const SizedBox(height: 2),
                                Expanded(
                                  child: Text(
                                    data['location']?.toString() ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
