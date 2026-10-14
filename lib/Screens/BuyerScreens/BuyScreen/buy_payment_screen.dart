import 'package:figma2/Screens/BuyerScreens/BuyScreen/buy_models.dart';
import 'package:figma2/Screens/BuyerScreens/BuyScreen/buy_request_service.dart';
import 'package:figma2/Screens/BuyerScreens/BuyScreen/buy_success_screen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BuyPaymentScreen extends StatefulWidget {
  final List<BuyCartItem> items;
  final int rentalDays;
  final double subtotal;
  final double serviceFee;
  final double total;

  const BuyPaymentScreen({
    super.key,
    required this.items,
    required this.rentalDays,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
  });

  @override
  State<BuyPaymentScreen> createState() => _BuyPaymentScreenState();
}

class _BuyPaymentScreenState extends State<BuyPaymentScreen> {
  String _method = 'card';
  final _nameCtrl = TextEditingController(text: 'John Doe');
  final _cardCtrl = TextEditingController(text: '4242 4242 4242 4242');
  final _expiryCtrl = TextEditingController(text: '12/28');
  final _cvvCtrl = TextEditingController(text: '123');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    EasyLoading.show(status: 'Processing payment...');
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      final orderId = await BuyRequestService.createRequests(
        items: widget.items,
        rentalDays: widget.rentalDays,
        subtotal: widget.subtotal,
        serviceFee: widget.serviceFee,
        total: widget.total,
        paymentMethod: _methodLabel,
      );
      EasyLoading.dismiss();
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => BuySuccessScreen(
            orderId: orderId,
            total: widget.total,
            itemCount: widget.items.fold(0, (s, i) => s + i.quantity),
            rentalDays: widget.rentalDays,
            paymentMethod: _methodLabel,
          ),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      EasyLoading.showError('Could not create buy request');
      // ignore: avoid_print
      print('buy request failed: $e');
    }
  }

  String get _methodLabel {
    switch (_method) {
      case 'paypal':
        return 'PayPal';
      case 'bank':
        return 'Bank Transfer';
      default:
        return 'Card';
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
          'Payment',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order summary',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.items.length} product(s) · ${widget.rentalDays} days',
                  style: const TextStyle(fontSize: 12, color: Color(0xff7D756C)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Amount due',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '\$${widget.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: primaryClr,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Select payment method',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          _methodTile(
            value: 'card',
            title: 'Credit / Debit Card',
            subtitle: 'Visa, Mastercard, dummy card',
            icon: Icons.credit_card,
          ),
          _methodTile(
            value: 'paypal',
            title: 'PayPal',
            subtitle: 'Pay with PayPal balance',
            leading: Image.asset('assets/174861.png', height: 22),
          ),
          _methodTile(
            value: 'bank',
            title: 'Bank Account',
            subtitle: 'Dummy bank transfer',
            leading: Image.asset('assets/3771347.png', height: 22),
          ),
          if (_method == 'card') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _field(_nameCtrl, 'Cardholder name'),
                  const SizedBox(height: 10),
                  _field(_cardCtrl, 'Card number',
                      keyboard: TextInputType.number),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _field(_expiryCtrl, 'MM/YY'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _field(_cvvCtrl, 'CVV',
                            keyboard: TextInputType.number),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Demo only — payment is simulated and nothing is charged.',
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
              onPressed: _pay,
              child: Text(
                'Pay \$${widget.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _methodTile({
    required String value,
    required String title,
    required String subtitle,
    IconData? icon,
    Widget? leading,
  }) {
    final selected = _method == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => _method = value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? primaryClr : const Color(0xff928D8D),
                  size: 22,
                ),
                const SizedBox(width: 8),
                leading ??
                    Icon(icon, color: selected ? primaryClr : blackclr),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xff7D756C),
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
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        filled: true,
        fillColor: const Color(0xffF4F4F4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
