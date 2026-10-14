import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/BuyScreen/buy_models.dart';
import 'package:figma2/main.dart';

class BuyRequestService {
  BuyRequestService._();

  static final _orders = FirebaseFirestore.instance.collection('buy_requests');

  /// Creates one buy request per seller after dummy payment success.
  static Future<String> createRequests({
    required List<BuyCartItem> items,
    required int rentalDays,
    required double subtotal,
    required double serviceFee,
    required double total,
    required String paymentMethod,
  }) async {
    final buyerUid = box.read('uid')?.toString() ?? '';
    final buyerName = await _buyerName(buyerUid);
    final orderId =
        'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final bySeller = <String, List<BuyCartItem>>{};
    for (final item in items) {
      final seller = (item.sellerUid ?? '').trim().isEmpty
          ? 'unknown'
          : item.sellerUid!.trim();
      bySeller.putIfAbsent(seller, () => []).add(item);
    }

    final batch = FirebaseFirestore.instance.batch();
    final now = FieldValue.serverTimestamp();

    bySeller.forEach((sellerUid, sellerItems) {
      final sellerSubtotal =
          sellerItems.fold<double>(0, (s, i) => s + i.lineTotal) * rentalDays;
      final sellerFee = sellerSubtotal * 0.05;
      final sellerTotal = sellerSubtotal + sellerFee;
      final ref = _orders.doc();

      batch.set(ref, {
        'orderId': orderId,
        'sellerUid': sellerUid,
        'buyerUid': buyerUid,
        'buyerName': buyerName,
        'paymentStatus': 'success',
        'paymentMethod': paymentMethod,
        'rentalDays': rentalDays,
        'subtotal': sellerSubtotal,
        'serviceFee': sellerFee,
        'total': sellerTotal,
        'orderSubtotal': subtotal,
        'orderServiceFee': serviceFee,
        'orderTotal': total,
        'status': 'new',
        'createdAt': now,
        'items': sellerItems.map((e) => e.toMap()).toList(),
        'itemCount': sellerItems.fold<int>(0, (s, i) => s + i.quantity),
      });
    });

    await batch.commit();
    return orderId;
  }

  static Future<String> _buyerName(String uid) async {
    if (uid.isEmpty) return 'Guest Buyer';
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final name = snap.data()?['name']?.toString();
      if (name != null && name.trim().isNotEmpty) return name.trim();
    } catch (_) {}
    return 'Buyer';
  }
}
