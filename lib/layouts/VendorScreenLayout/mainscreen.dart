import 'package:figma2/Screens/SellerScreens/MessageScreen/sellmessage.dart';
import 'package:figma2/Screens/SellerScreens/SellScreen/sellscreen.dart';
import 'package:flutter/material.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/model.dart';

import '../../Screens/SellerScreens/LocationScreen/locationscreen.dart';
import '../../Screens/SellerScreens/ProfileScreen/sellProfile.dart';
import '../../Utilities/Colors/color.dart';

class ScreenLayout extends StatefulWidget {
  const ScreenLayout({super.key});

  @override
  State<ScreenLayout> createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout> {
  String page = 'Home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 7),
        child: FloatingActionButton(
            child: const Center(
              child: Text(
                "Sell",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            onPressed: () {}),
      ),
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 70,
        child: PandaBar(
          buttonSelectedColor: primaryClr,
          buttonColor: blackclr,
          backgroundColor: wbackgroundclr,
          buttonData: [
            PandaBarButtonData(id: 'Home', icon: Icons.home, title: 'Home'),
            PandaBarButtonData(
                id: 'Messages', icon: Icons.message_sharp, title: 'Messages'),
            PandaBarButtonData(
                id: 'Location',
                icon: Icons.location_on_outlined,
                title: 'Location'),
            PandaBarButtonData(
                id: 'Profile', icon: Icons.person_outline, title: 'Profile'),
          ],
          onChange: (id) {
            setState(() {
              page = id;
            });
          },
          onFabButtonPressed: () {},
        ),
      ),
      body: Builder(
        builder: (context) {
          switch (page) {
            case 'Home':
              return const SellScreen();
            case 'Messages':
              return const SellMessageScreen();
            case 'Location':
              return const Lcat();
            case 'Profile':
              return const SellProfile();
            default:
              return Container();
          }
        },
      ),
    );
  }
}
