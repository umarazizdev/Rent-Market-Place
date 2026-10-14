import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/HomeScreen/detailscreen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:flutter/material.dart';

class SeeAllScreen extends StatefulWidget {
  final String categoryName;
  final bool showLocation;
  const SeeAllScreen(
      {super.key, required this.categoryName, required this.showLocation});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  late final Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('products')
        .where('Category', isEqualTo: widget.categoryName)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        backgroundColor: primaryClr,
        title: Text(widget.categoryName,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: primaryClr));
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text("No ${widget.categoryName} found"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetUserName(documentId: docId),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xff928D8D)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeNetworkImage(
                        url: data['image']?.toString(),
                        height: 100,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['title']?.toString() ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        "Rs ${data['price']?.toString() ?? ''}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: primaryClr,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
