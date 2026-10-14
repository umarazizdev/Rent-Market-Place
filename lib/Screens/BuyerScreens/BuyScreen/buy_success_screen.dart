import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';

class BuySuccessScreen extends StatelessWidget {
  final String orderId;
  final double total;
  final int itemCount;
  final int rentalDays;
  final String paymentMethod;

  const BuySuccessScreen({
    super.key,
    required this.orderId,
    required this.total,
    required this.itemCount,
    required this.rentalDays,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wbackgroundclr,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                height: 88,
                width: 88,
                decoration: const BoxDecoration(
                  color: Color(0xffE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xff2E7D32),
                  size: 56,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Order placed!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Payment succeeded and your buy request was sent to the seller.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff7D756C),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: gbackgroundClr,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _info('Order ID', orderId),
                    const SizedBox(height: 10),
                    _info('Items', '$itemCount'),
                    const SizedBox(height: 10),
                    _info('Duration', '$rentalDays days'),
                    const SizedBox(height: 10),
                    _info('Payment', paymentMethod),
                    const SizedBox(height: 10),
                    _info(
                      'Total paid',
                      '\$${total.toStringAsFixed(0)}',
                      highlight: true,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xff7D756C)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: highlight ? primaryClr : blackclr,
          ),
        ),
      ],
    );
  }
}
