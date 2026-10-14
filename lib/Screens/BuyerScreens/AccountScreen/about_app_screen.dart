import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const String appName = 'Rent Marketplace';
  static const String version = '1.0.0';
  static const String description =
      'Rent Marketplace connects owners and renters in one place. '
      'List items to rent, browse categories, chat with sellers, '
      'and place demo rental orders — all from your phone.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        backgroundColor: primaryClr,
        foregroundColor: Colors.white,
        title: const Text(
          'About App',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/figma2.png',
                    height: 72,
                    width: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: primaryClr,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.home_work,
                          color: Colors.white, size: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  appName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version $version',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff7D756C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _card(
            title: 'About',
            child: const Text(
              description,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xff5A5757),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _card(
            title: 'Features',
            child: Column(
              children: const [
                _FeatureRow(
                  icon: Icons.inventory_2_outlined,
                  text: 'List and browse rental products by category',
                ),
                _FeatureRow(
                  icon: Icons.chat_bubble_outline,
                  text: 'Chat with sellers and buyers in-app',
                ),
                _FeatureRow(
                  icon: Icons.map_outlined,
                  text: 'Find listings with map & location',
                ),
                _FeatureRow(
                  icon: Icons.shopping_bag_outlined,
                  text: 'Demo buy / rent checkout flow',
                ),
                _FeatureRow(
                  icon: Icons.person_outline,
                  text: 'Manage your profile and listings',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _card(
            title: 'App info',
            child: Column(
              children: const [
                _InfoRow(label: 'App name', value: appName),
                SizedBox(height: 10),
                _InfoRow(label: 'Version', value: version),
                SizedBox(height: 10),
                _InfoRow(label: 'Platform', value: 'Flutter (iOS & Android)'),
                SizedBox(height: 10),
                _InfoRow(label: 'Auth', value: 'Firebase Authentication'),
                SizedBox(height: 10),
                _InfoRow(label: 'Database', value: 'Cloud Firestore'),
                SizedBox(height: 10),
                _InfoRow(label: 'Storage', value: 'Supabase Storage'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _card(
            title: 'Contact',
            child: const Text(
              'For inquiries, contact umar.aziz.dev@gmail.com',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xff5A5757),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: primaryClr),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Color(0xff5A5757),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xff7D756C)),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
