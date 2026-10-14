import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';
import '../Colors/color.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (context, snapshot) {
        String userName = "Anjalia Rutherford";
        String? avatarUrl;

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          userName = data['name']?.toString() ?? "Anjalia Rutherford";
          avatarUrl = data['avatar']?.toString();
        }

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // UI SAME, bas image dynamic
                  avatarUrl != null && avatarUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SafeNetworkImage(
                            url: avatarUrl,
                            height: 30,
                            width: 30,
                          ),
                        )
                      : Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/profilephoto.png"),
                              ),
                              shape: BoxShape.circle,
                              color: Colors.red),
                        ),
                  const SizedBox(width: 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hi..",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        userName, // DYNAMIC
                        style: const TextStyle(
                            color: textClr,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Material(
                  elevation: 3,
                  child: Container(
                    height: 17,
                    width: 75,
                    decoration: const BoxDecoration(color: wbackgroundclr),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(Icons.location_on_outlined,
                            color: primaryClr, size: 12),
                        Text(
                          "My Location",
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}