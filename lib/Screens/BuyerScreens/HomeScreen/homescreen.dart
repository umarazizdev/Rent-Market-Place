import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/HomeScreen/detailscreen.dart';
import 'package:figma2/Screens/BuyerScreens/HomeScreen/see_all_screen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
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
  String _searchQuery = "";

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

  Stream<QuerySnapshot> get _searchStream =>
      FirebaseFirestore.instance.collection('products').snapshots();

  // FIXED: Ab sirf 2 parameter - stream ki zarurat nahi
  void _goToSeeAll(String name, bool location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SeeAllScreen(
          categoryName: name,
          showLocation: location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size sc = Utils().getScreenSize();
    final sizedBox = SizedBox(height: sc.height * 0.03);
    final spaceThingy = SizedBox(height: sc.height * 0.01);
    bool isSearching = _searchQuery.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: gbackgroundClr,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const ProfileWidget(),
              sizedBox,
              SearchWidget(
                sc: sc,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase();
                  });
                },
              ),
              sizedBox,
              const LogosListWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: isSearching
                   ? Column(
                        children: [
                          SeeWidget(
                              text1: 'Search Result for "$_searchQuery"',
                              text2: ''),
                          StreamBuilder<QuerySnapshot>(
                            stream: _searchStream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox(
                                  height: 110,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 3, color: primaryClr)),
                                );
                              }
                              var filtered = snapshot.data!.docs.where((doc) {
                                var title = (doc['title']?? '')
                                   .toString()
                                   .toLowerCase();
                                var category = (doc['Category']?? '')
                                   .toString()
                                   .toLowerCase();
                                return title.contains(_searchQuery) ||
                                    category.contains(_searchQuery);
                              }).toList();

                              if (filtered.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text("No product found"),
                                );
                              }
                              return SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final data = filtered[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 7.0, right: 7, top: 7),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GetUserName(
                                                      documentId: data.id),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 96,
                                          width: 69,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xff928D8D)),
                                          ),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SafeNetworkImage(
                                                url: data['image']?.toString(),
                                                height: 36,
                                                width: double.infinity,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                data['title'].toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          InkWell(
                            onTap: () => _goToSeeAll('Car', true),
                            child: const SeeWidget(
                                text1: 'Categories', text2: 'see all'),
                          ),
                          CategoryWidget(
                              stream: _usersStream, location: true),
                          spaceThingy,
                          InkWell(
                            onTap: () => _goToSeeAll('Home', true), // FIXED: Property -> Home
                            child: const SeeWidget(
                                text1: 'Property', text2: 'see all'),
                          ),
                          CategoryWidget(stream: _homeStream, location: true),
                          spaceThingy,
                          InkWell(
                            onTap: () => _goToSeeAll('Furniture', false),
                            child: const SeeWidget(
                                text1: 'Furniture', text2: 'see all'),
                          ),
                          CategoryWidget(
                              stream: _furnitureStream, location: false),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => _goToSeeAll('Books', false),
                            child: const SeeWidget(
                                text1: 'Books', text2: 'see all'),
                          ),
                          CategoryWidget(
                              stream: _booksStream, location: false),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => _goToSeeAll('Clothes', false),
                            child: const SeeWidget(
                                text1: 'Clothes', text2: 'see all'),
                          ),
                          CategoryWidget(
                              stream: _clothesStream, location: false),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => _goToSeeAll('Services', false),
                            child: const SeeWidget(
                                text1: 'Services', text2: 'see all'),
                          ),
                          CategoryWidget(
                              stream: _servicesStream, location: false),
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