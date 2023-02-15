import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/MessageScreen/chatscreen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
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
    CollectionReference _usersStream =
        FirebaseFirestore.instance.collection('products');

    return FutureBuilder<DocumentSnapshot>(
      future: _usersStream.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
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
                      Container(
                        height: sc.height * 0.3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              data['image'],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sc.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['title'],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['price'],
                            style: const TextStyle(
                                color: primaryClr,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: sc.height * 0.02),
                      Text(
                        data['location'],
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
                        data['description'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: sc.height * 0.1),
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
        }

        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 1,
            color: primaryClr,
          ),
        );
      },
    );
  }
}
