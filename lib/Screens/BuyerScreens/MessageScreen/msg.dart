import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class MsgScreen extends StatefulWidget {
  const MsgScreen({super.key});

  @override
  State<MsgScreen> createState() => _MsgScreenState();
}

class _MsgScreenState extends State<MsgScreen> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Messages')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  height: 30,
                  width: 290,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: whiteclr,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        size: 23,
                        color: primaryClr.withOpacity(0.6),
                      ),
                      enabledBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      labelText: 'Search',
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(id: ),));
              //   },
              //   child: ListTile(
              //     leading: const CircleAvatar(),
              //     trailing: const Opacity(
              //       opacity: 0.6,
              //       child: Text(
              //         "2:30 am",
              //       ),
              //     ),
              //     title: Text(
              //       box.read(
              //         'uid',
              //       ),
              //       style: const TextStyle(
              //         fontSize: 13.5,
              //         color: blackclr,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
              // /*
              StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: primaryClr,
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ChatScreen(
                          //       id: ,
                          //     ),
                          //   ),
                          // );
                        },
                        child: ListTile(
                          leading: const CircleAvatar(),
                          trailing: const Opacity(
                            opacity: 0.6,
                            child: Text(
                              "2:30 am",
                            ),
                          ),
                          title: Text(
                            box.read('uid'),
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: blackclr,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // */
            ],
          ),
        ),
      ),
    );
  }
}
