import 'package:figma2/Screens/BuyerScreens/AccountScreen/profilescreen.dart';
import 'package:figma2/Screens/BuyerScreens/BoosterScreen/boostscreen.dart';
import 'package:figma2/Screens/BuyerScreens/HomeScreen/homescreen.dart';
import 'package:figma2/Screens/BuyerScreens/MessageScreen/inbox.dart';
import 'package:flutter/material.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/model.dart';

import '../../Utilities/Colors/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size sc = Utils().getScreenSize();
  String page = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 7),
        child: FloatingActionButton(
           shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text(
                "Buy",
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
              return const HomeScreen();
            case 'Messages':
              return const BuyerInbox();
            case 'Location':
              return const BoosterScreen();
            case 'Profile':
              return const ProfileScreen();
            default:
              return Container();
          }
        },
      ),
    );
  }
}
