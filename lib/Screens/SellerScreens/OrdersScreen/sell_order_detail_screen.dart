import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SellOrderDetailScreen extends StatelessWidget {
  final String requestId;

  const SellOrderDetailScreen({super.key, required this.requestId});

  Future<void> _updateStatus(BuildContext context, String status) async {
    EasyLoading.show(status: 'Updating...');
    try {
      await FirebaseFirestore.instance
          .collection('buy_requests')
          .doc(requestId)
          .update({'status': status});
      EasyLoading.showSuccess(
        status == 'accepted' ? 'Request accepted' : 'Request rejected',
      );
    } catch (e) {
      EasyLoading.showError('Update failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        backgroundColor: primaryClr,
        foregroundColor: Colors.white,
        title: const Text(
          'Order Details',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('buy_requests')
            .doc(requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator(color: primaryClr));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = (data['items'] as List?) ?? [];
          final status = data['status']?.toString() ?? 'new';
          final createdAt = data['createdAt'];
          String dateLabel = '-';
          if (createdAt is Timestamp) {
            final d = createdAt.toDate();
            dateLabel =
                '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              _box(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['orderId']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xffE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Payment Success',
                            style: TextStyle(
                              color: Color(0xff2E7D32),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _kv('Status', status.toUpperCase()),
                    _kv('Buyer', data['buyerName']?.toString() ?? '-'),
                    _kv('Payment', data['paymentMethod']?.toString() ?? '-'),
                    _kv('Rental days', '${data['rentalDays'] ?? '-'}'),
                    _kv('Placed at', dateLabel),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ordered items',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...items.map((raw) {
                final item = Map<String, dynamic>.from(raw as Map);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SafeNetworkImage(
                        url: item['image']?.toString(),
                        height: 54,
                        width: 54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']?.toString() ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Qty ${item['quantity'] ?? 1} · ${item['priceLabel'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff7D756C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              _box(
                child: Column(
                  children: [
                    _moneyRow(
                        'Subtotal', data['subtotal'] as num? ?? 0),
                    const SizedBox(height: 8),
                    _moneyRow(
                        'Service fee', data['serviceFee'] as num? ?? 0),
                    const Divider(height: 22),
                    _moneyRow(
                      'Total paid',
                      data['total'] as num? ?? 0,
                      bold: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _updateStatus(context, 'rejected'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xffC62828),
                    side: const BorderSide(color: Color(0xffC62828)),
                    minimumSize: const Size.fromHeight(44),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateStatus(context, 'accepted'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryClr,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                  ),
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xff7D756C)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyRow(String label, num value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 14 : 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: FontWeight.w700,
            color: bold ? primaryClr : blackclr,
          ),
        ),
      ],
    );
  }
}
