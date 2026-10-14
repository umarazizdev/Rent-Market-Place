import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/SellerScreens/OrdersScreen/sell_order_detail_screen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';

class SellOrdersScreen extends StatelessWidget {
  const SellOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sellerUid = box.read('uid')?.toString() ?? '';

    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        backgroundColor: primaryClr,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Buy Requests',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: sellerUid.isEmpty
          ? const Center(child: Text('Please log in to view orders'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('buy_requests')
                  .where('sellerUid', isEqualTo: sellerUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryClr),
                  );
                }

                final docs = [...(snapshot.data?.docs ?? [])];
                docs.sort((a, b) {
                  final aTime = (a.data() as Map)['createdAt'];
                  final bTime = (b.data() as Map)['createdAt'];
                  if (aTime is Timestamp && bTime is Timestamp) {
                    return bTime.compareTo(aTime);
                  }
                  return 0;
                });

                if (docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No buy requests yet.\nWhen a buyer completes payment, orders will show here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff7D756C),
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final items = (data['items'] as List?) ?? [];
                    final firstImage = items.isNotEmpty
                        ? (items.first as Map)['image']?.toString()
                        : null;
                    final status = data['status']?.toString() ?? 'new';
                    final payment =
                        data['paymentStatus']?.toString() ?? 'success';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SellOrderDetailScreen(
                                  requestId: doc.id,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                SafeNetworkImage(
                                  url: firstImage,
                                  height: 64,
                                  width: 64,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['orderId']?.toString() ?? '',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Buyer: ${data['buyerName'] ?? 'Unknown'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff7D756C),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${data['itemCount'] ?? items.length} item(s) · ${data['rentalDays'] ?? '-'} days',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          _chip(
                                            payment == 'success'
                                                ? 'Paid'
                                                : payment,
                                            payment == 'success'
                                                ? const Color(0xff2E7D32)
                                                : const Color(0xff7D756C),
                                          ),
                                          const SizedBox(width: 6),
                                          _chip(
                                            status.toUpperCase(),
                                            status == 'new'
                                                ? primaryClr
                                                : status == 'accepted'
                                                    ? const Color(0xff2E7D32)
                                                    : const Color(0xffC62828),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${(data['total'] as num?)?.toStringAsFixed(0) ?? '0'}',
                                      style: const TextStyle(
                                        color: primaryClr,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xff928D8D),
                                    ),
                                  ],
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
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
