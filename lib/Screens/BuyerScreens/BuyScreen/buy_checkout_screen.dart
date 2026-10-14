import 'package:figma2/Screens/BuyerScreens/BuyScreen/buy_models.dart';
import 'package:figma2/Screens/BuyerScreens/BuyScreen/buy_payment_screen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/Utilities/Widgets/safe_network_image.dart';
import 'package:flutter/material.dart';

class BuyCheckoutScreen extends StatefulWidget {
  final List<BuyCartItem> items;

  const BuyCheckoutScreen({super.key, required this.items});

  @override
  State<BuyCheckoutScreen> createState() => _BuyCheckoutScreenState();
}

class _BuyCheckoutScreenState extends State<BuyCheckoutScreen> {
  late List<BuyCartItem> _items;
  int _rentalDays = 7;

  @override
  void initState() {
    super.initState();
    _items = widget.items.map((e) => e.copy()).toList();
  }

  double get _subtotal =>
      _items.fold<double>(0, (sum, item) => sum + item.lineTotal) * _rentalDays;

  double get _serviceFee => (_subtotal * 0.05).clamp(0, double.infinity);

  double get _total => _subtotal + _serviceFee;

  void _goToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuyPaymentScreen(
          items: _items,
          rentalDays: _rentalDays,
          subtotal: _subtotal,
          serviceFee: _serviceFee,
          total: _total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        backgroundColor: primaryClr,
        foregroundColor: Colors.white,
        title: const Text(
          'Checkout',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          const Text(
            'Selected items',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ..._items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SafeNetworkImage(
                    url: item.image,
                    height: 58,
                    width: 58,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.priceLabel} / day',
                          style: const TextStyle(
                            fontSize: 12,
                            color: primaryClr,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          setState(() {
                            if (item.quantity > 1) item.quantity--;
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          setState(() => item.quantity++);
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rental duration',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [3, 7, 14, 30].map((days) {
                    final selected = _rentalDays == days;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('$days days'),
                        selected: selected,
                        selectedColor: primaryClr,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : blackclr,
                          fontSize: 12,
                        ),
                        onSelected: (_) => setState(() => _rentalDays = days),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _row('Subtotal ($_rentalDays days)',
                    '\$${_subtotal.toStringAsFixed(0)}'),
                const SizedBox(height: 8),
                _row('Service fee (5%)', '\$${_serviceFee.toStringAsFixed(0)}'),
                const Divider(height: 24),
                _row(
                  'Total',
                  '\$${_total.toStringAsFixed(0)}',
                  bold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'This is a demo checkout. No real payment will be charged.',
            style: TextStyle(fontSize: 11, color: Color(0xff7D756C)),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          color: Colors.white,
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryClr,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _goToPayment,
              child: Text(
                'Proceed to Payment  ·  \$${_total.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: bold ? primaryClr : blackclr,
          ),
        ),
      ],
    );
  }
}
