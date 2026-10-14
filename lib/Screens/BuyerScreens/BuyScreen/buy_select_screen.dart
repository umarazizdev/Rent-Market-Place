import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/BuyScreen/buy_checkout_screen.dart';
import 'package:figma2/Screens/BuyerScreens/BuyScreen/buy_models.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:flutter/material.dart';

class BuySelectScreen extends StatefulWidget {
  const BuySelectScreen({super.key});

  @override
  State<BuySelectScreen> createState() => _BuySelectScreenState();
}

class _BuySelectScreenState extends State<BuySelectScreen> {
  final Map<String, BuyCartItem> _selected = {};
  String _category = 'All';

  static const _categories = [
    'All',
    'Car',
    'Home',
    'Furniture',
    'Books',
    'Clothes',
  ];

  void _toggle(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    setState(() {
      if (_selected.containsKey(doc.id)) {
        _selected.remove(doc.id);
      } else {
        _selected[doc.id] = BuyCartItem(
          id: doc.id,
          title: data['title']?.toString() ?? 'Untitled',
          priceLabel: data['price']?.toString() ?? '0',
          image: data['image']?.toString(),
          location: data['location']?.toString(),
          category: data['Category']?.toString(),
          sellerUid: data['uid']?.toString(),
        );
      }
    });
  }

  void _continue() {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one product to buy')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuyCheckoutScreen(
          items: _selected.values.toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('products');
    if (_category != 'All') {
      query = query.where('Category', isEqualTo: _category);
    }

    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        backgroundColor: primaryClr,
        foregroundColor: Colors.white,
        title: const Text(
          'Buy Products',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat == _category;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  selectedColor: primaryClr,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : blackclr,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (_) => setState(() => _category = cat),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryClr),
                  );
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final isSelected = _selected.containsKey(doc.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _toggle(doc),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  activeColor: primaryClr,
                                  onChanged: (_) => _toggle(doc),
                                ),
                                SafeNetworkImage(
                                  url: data['image']?.toString(),
                                  height: 64,
                                  width: 64,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['title']?.toString() ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data['Category']?.toString() ?? '',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xff7D756C),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data['price']?.toString() ?? '',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: primaryClr,
                                          fontWeight: FontWeight.w700,
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selected.isEmpty
                      ? 'No items selected'
                      : '${_selected.length} item(s) selected',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryClr,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _continue,
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
