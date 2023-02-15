import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
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
              const SizedBox(
                width: 3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hi..",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Anjalia Rutherford",
                    style: TextStyle(
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
                      style:
                          TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // StreamBuilder<QuerySnapshot>(
    //   stream: _usersStream,
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text('Something went wrong');
    //     }

    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Text("Loading");
    //     }
    //     final data = snapshot.data!.docs;
    //     return SizedBox(
    //       height: 50,
    //       child: ListView.builder(
    //         shrinkWrap: false,
    //         physics: ScrollPhysics(),
    //         scrollDirection: Axis.vertical,
    //         itemCount: snapshot.data!.docs.length,
    //         itemBuilder: (context, index) {
    //           return
    //         },
    //       ),
    // );
    // },
    // );
  }
}
