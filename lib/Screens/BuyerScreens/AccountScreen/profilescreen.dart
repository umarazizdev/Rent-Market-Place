import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/AccountScreen/profilepicture.dart';
import 'package:figma2/Screens/BuyerScreens/FavoriteScreen/favoritescreen.dart';
import 'package:figma2/Utilities/SignInScreen/loginscreen.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/Colors/color.dart';
import '../MessageScreen/messagescreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();

  signOut() async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          // data nikalna
          String userName = "Anjlia Rutherford";
          String? avatarUrl;
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
            userName = data['name']?.toString() ?? "Anjlia Rutherford";
            avatarUrl = data['avatar']?.toString();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 428,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: primaryClr,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 38),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePhotoScreen(),
                                ));
                          },
                          child: Row(
                            children: [
                              // UI SAME, bas avatar dynamic
                              avatarUrl != null && avatarUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: SafeNetworkImage(
                                        url: avatarUrl,
                                        height: 60,
                                        width: 60,
                                      ),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            "assets/profilephoto.png",
                                          ),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName, // DYNAMIC NAME
                                      style: const TextStyle(
                                          color: whiteclr,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      "View And Edit Profile",
                                      style: TextStyle(
                                          color: whiteclr,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Row(
                          children: [
                            Image.asset("assets/megaphone (1) 2.png", height: 27),
                            const SizedBox(width: 14),
                            const Text("Create Listing", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xffD9D9D9)),
                      const SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Row(
                          children: [
                            Image.asset("assets/gift 1.png", height: 27),
                            const SizedBox(width: 14),
                            const Text("Offers", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Divider(color: Color(0xffD9D9D9)),
                      const SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Row(
                          children: [
                            Image.asset("assets/clipboard-with-pencil- 1.png", height: 27),
                            const SizedBox(width: 14),
                            const Text("My Pakages", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Divider(color: Color(0xffD9D9D9)),
                      const SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Row(
                          children: [
                            Image.asset("assets/upgrade (1) 1.png", height: 27),
                            const SizedBox(width: 14),
                            const Text("Upgrade Pakages", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Divider(color: Color(0xffD9D9D9)),
                      const SizedBox(height: 13),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriteScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Row(
                            children: [
                              Image.asset("assets/heart (1) 1.png", height: 27),
                              const SizedBox(width: 14),
                              const Text("My Favourites", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Divider(color: Color(0xffD9D9D9)),
                      const SizedBox(height: 13),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MessageScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Row(
                            children: [
                              Image.asset("assets/notification (1) 1.png", height: 27),
                              const SizedBox(width: 14),
                              const Text("Notofication", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Divider(color: Color(0xffD9D9D9)),
                      const SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Row(
                          children: [
                            Image.asset("assets/info-button 1.png", height: 27),
                            const SizedBox(width: 14),
                            const Text("About", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Divider(color: Color(0xffD9D9D9)),
                      const SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: InkWell(
                          onTap: () => signOut(),
                          child: Row(
                            children: [
                              Image.asset("assets/switch 1.png", height: 27),
                              const SizedBox(width: 14),
                              const Text("Log Out", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Divider(color: Color(0xffD9D9D9)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}