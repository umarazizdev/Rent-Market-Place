import 'package:flutter/material.dart';

/// Loads network images safely. Old Firebase Storage URLs are skipped
/// (they return 402 / invalid data) and show a placeholder instead.
class SafeNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;

  const SafeNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
  });

  static bool isUnusableUrl(String? url) {
    if (url == null || url.trim().isEmpty) return true;
    final lower = url.toLowerCase();
    // Firebase Storage is locked on this project (HTTP 402) — don't decode.
    if (lower.contains('firebasestorage.googleapis.com')) return true;
    if (lower.contains('appspot.com') && lower.contains('/o/')) return true;
    // Broken external placeholder used previously in this app.
    if (lower.contains('lightsong.net')) return true;
    return false;
  }

  Widget _placeholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: const Color(0xffD9D9D9),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_outlined,
            color: Color(0xff928D8D),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final image = isUnusableUrl(url)
        ? _placeholder()
        : Image.network(
            url!,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _placeholder(),
          );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: SizedBox(
          width: width,
          height: height,
          child: image,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: image,
    );
  }
}

/// Circular avatar that never throws on bad network URLs.
class SafeAvatar extends StatelessWidget {
  final String? url;
  final double radius;
  final String assetFallback;

  const SafeAvatar({
    super.key,
    required this.url,
    this.radius = 20,
    this.assetFallback = 'assets/profilephoto.png',
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xffD9D9D9),
      child: ClipOval(
        child: SafeNetworkImage.isUnusableUrl(url)
            ? Image.asset(
                assetFallback,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: radius,
                  color: const Color(0xff928D8D),
                ),
              )
            : Image.network(
                url!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  assetFallback,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.person,
                    size: radius,
                    color: const Color(0xff928D8D),
                  ),
                ),
              ),
      ),
    );
  }
}
