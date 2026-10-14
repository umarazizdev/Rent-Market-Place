import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/AccountScreen/about_app_screen.dart';
import 'package:figma2/Screens/BuyerScreens/AccountScreen/profilepicture.dart';
import 'package:figma2/Screens/BuyerScreens/FavoriteScreen/favoritescreen.dart';
import 'package:figma2/Utilities/SignInScreen/loginscreen.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/Colors/color.dart';

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

  Future<void> signOut() async {
    await auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          String userName = 'User';
          String? avatarUrl;
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final data =
                snapshot.data!.docs.first.data() as Map<String, dynamic>;
            userName = data['name']?.toString().trim().isNotEmpty == true
                ? data['name'].toString()
                : 'User';
            avatarUrl = data['avatar']?.toString();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  color: primaryClr,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 38),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePhotoScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
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
                                        'assets/profilephoto.png',
                                      ),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: whiteclr,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'View And Edit Profile',
                                  style: TextStyle(
                                    color: whiteclr,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      _ProfileTile(
                        asset: 'assets/heart (1) 1.png',
                        title: 'My Favourites',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoriteScreen(),
                            ),
                          );
                        },
                      ),
                      _ProfileTile(
                        asset: 'assets/info-button 1.png',
                        title: 'About App',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutAppScreen(),
                            ),
                          );
                        },
                      ),
                      _ProfileTile(
                        asset: 'assets/switch 1.png',
                        title: 'Log Out',
                        onTap: signOut,
                        showDivider: false,
                      ),
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

class _ProfileTile extends StatelessWidget {
  final String asset;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const _ProfileTile({
    required this.asset,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            child: Row(
              children: [
                Image.asset(asset, height: 27),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xff928D8D),
                ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(color: Color(0xffD9D9D9), height: 1),
      ],
    );
  }
}
