import 'package:figma2/Screens/BuyerScreens/MessageScreen/message.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../main.dart';
import 'bottommessagebar.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  const ChatScreen({
    super.key,
    required this.id,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.id)
        .snapshots();
    Size sc = Utils().getScreenSize();
    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: primaryClr),
        backgroundColor: wbackgroundclr.withOpacity(0.6),
        elevation: 0,
        title: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }

            return ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: data['image'] == true
                          ? NetworkImage(
                              data['avatar'],
                            )
                          : const NetworkImage(
                              "https://www.lightsong.net/wp-content/uploads/2020/12/blank-profile-circle.png",
                            ),
                    ),
                    SizedBox(
                      width: sc.width * 0.013,
                    ),
                    SizedBox(
                      width: sc.width * 0.29,
                      child: Text(
                        data['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 13,
                            color: blackclr,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Messages(
            id: widget.id,
          ),
          BottomMeassageBar(
            id: widget.id,
          ),
        ],
      ),
    );
  }
}
