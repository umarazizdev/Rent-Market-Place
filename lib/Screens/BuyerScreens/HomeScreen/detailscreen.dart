import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/MessageScreen/chatscreen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatefulWidget {
  final String documentId;

  const GetUserName({super.key, required this.documentId});

  @override
  State<GetUserName> createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {
  @override
  Widget build(BuildContext context) {
    Size sc = Utils().getScreenSize();
    final productRef =
        FirebaseFirestore.instance.collection('products').doc(widget.documentId);
    final currentUid = box.read('uid')?.toString();

    return StreamBuilder<DocumentSnapshot>(
      stream: productRef.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: primaryClr,
              ),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Document does not exist")),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final isOwner = currentUid != null &&
            currentUid.isNotEmpty &&
            currentUid == data['uid']?.toString();
        final imageUrl = data['image']?.toString();

        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Product Details",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              height: 1.5,
                              width: 120,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: sc.height * 0.03),
                    SafeNetworkImage(
                      url: imageUrl,
                      height: sc.height * 0.3,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    SizedBox(height: sc.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['title']?.toString() ?? '',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data['price']?.toString() ?? '',
                          style: const TextStyle(
                              color: primaryClr,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: sc.height * 0.02),
                    Text(
                      data['location']?.toString() ?? '',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: sc.height * 0.03),
                    const Text(
                      "Description",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: blackclr),
                    ),
                    SizedBox(height: sc.height * 0.03),
                    Text(
                      data['description']?.toString() ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: sc.height * 0.1),
                    if (!isOwner)
                      Center(
                        child: SizedBox(
                          height: sc.height * 0.075,
                          width: sc.width * 0.7,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    id: data['uid'],
                                  ),
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
                              'Contact to Seller',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
