import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/Widgets/categorywidget.dart';
import '../../../Utilities/Widgets/logoslistwidget.dart';
import '../../../Utilities/Widgets/profilewidget.dart';
import '../../../Utilities/Widgets/searchwidget.dart';
import '../../../Utilities/Widgets/seewidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('products')
      .where('Category', isEqualTo: 'Car')
      .snapshots();
  final Stream<QuerySnapshot> _homeStream = FirebaseFirestore.instance
      .collection('products')
      .where('Category', isEqualTo: 'Home')
      .snapshots();
  final Stream<QuerySnapshot> _furnitureStream = FirebaseFirestore.instance
      .collection('products')
      .where('Category', isEqualTo: 'Furniture')
      .snapshots();
  final Stream<QuerySnapshot> _booksStream = FirebaseFirestore.instance
      .collection('products')
      .where('Category', isEqualTo: 'Books')
      .snapshots();
  final Stream<QuerySnapshot> _clothesStream = FirebaseFirestore.instance
      .collection('products')
      .where('Category', isEqualTo: 'Clothes')
      .snapshots();
  final Stream<QuerySnapshot> _servicesStream = FirebaseFirestore.instance
      .collection('products')
      .where('Category', isEqualTo: 'Services')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    Size sc = Utils().getScreenSize();
    final sizedBox = SizedBox(
      height: sc.height * 0.03,
    );
    final spaceThingy = SizedBox(
      height: sc.height * 0.01,
    );
    return Scaffold(
      backgroundColor: gbackgroundClr,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const ProfileWidget(),
              sizedBox,
              SearchWidget(sc: sc),
              sizedBox,
              const LogosListWidget(),
              // Categories
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: Column(
                  children: [
                    const SeeWidget(
                      text1: 'Categories',
                      text2: 'see all',
                    ),
                    CategoryWidget(
                      stream: _usersStream,
                      location: true,
                    ),
                    // Property
                    spaceThingy,
                    const SeeWidget(
                      text1: 'Property',
                      text2: 'see all',
                    ),
                    CategoryWidget(
                      stream: _homeStream,
                      location: true,
                    ),
                    // Furniture
                    spaceThingy,
                    const SeeWidget(
                      text1: 'Furniture',
                      text2: 'see all',
                    ),
                    CategoryWidget(
                      stream: _furnitureStream,
                      location: false,
                    ),
                    //Books
                    const SeeWidget(
                      text1: 'Books',
                      text2: 'see all',
                    ),
                    CategoryWidget(
                      stream: _booksStream,
                      location: false,
                    ),
                    // Clothes
                    const SeeWidget(
                      text1: 'Clothes',
                      text2: 'see all',
                    ),
                    CategoryWidget(
                      stream: _clothesStream,
                      location: false,
                    ),
                    // Services
                    const SeeWidget(
                      text1: 'Services',
                      text2: 'see all',
                    ),
                    CategoryWidget(
                      stream: _servicesStream,
                      location: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
