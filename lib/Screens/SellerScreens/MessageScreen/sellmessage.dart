import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/SellerScreens/MessageScreen/sellchatscreen.dart.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellMessageScreen extends StatefulWidget {
  const SellMessageScreen({super.key});

  @override
  State<SellMessageScreen> createState() => _SellMessageScreenState();
}

class _SellMessageScreenState extends State<SellMessageScreen> {
  XFile? singleImage;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('inbox')
      .where('vendorid', isEqualTo: box.read('uid'))
      .snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        backgroundColor: wbackgroundclr,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "Seller inbox",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: primaryClr,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Container(
              height: 1,
              width: 90,
              decoration: const BoxDecoration(
                color: Color(0xff5A5757),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: primaryClr,
              ),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document1) {
              Map<String, dynamic> data1 =
                  document1.data()! as Map<String, dynamic>;

              return FutureBuilder<DocumentSnapshot>(
                future: users.doc(data1['customerid'].toString()).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("Document does not exist");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellChatScreen(
                                ven: data1['customerid'],
                                cus: data['name'],
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: data['image'] == true
                              ? NetworkImage(
                                  data['avatar'],
                                )
                              : const NetworkImage(
                                  "https://www.lightsong.net/wp-content/uploads/2020/12/blank-profile-circle.png",
                                ),
                        ),
                        title: Text(
                          data['name'],
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
            }).toList(),
          );
        },
      ),
    );
  }
}
