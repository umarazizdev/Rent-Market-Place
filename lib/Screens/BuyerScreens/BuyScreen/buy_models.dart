class BuyCartItem {
  final String id;
  final String title;
  final String priceLabel;
  final String? image;
  final String? location;
  final String? category;
  final String? sellerUid;
  int quantity;

  BuyCartItem({
    required this.id,
    required this.title,
    required this.priceLabel,
    this.image,
    this.location,
    this.category,
    this.sellerUid,
    this.quantity = 1,
  });

  /// Parses a rough numeric amount from labels like "$200", "Rs 150", "200".
  double get unitAmount {
    final cleaned = priceLabel.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  double get lineTotal => unitAmount * quantity;

  BuyCartItem copy() => BuyCartItem(
        id: id,
        title: title,
        priceLabel: priceLabel,
        image: image,
        location: location,
        category: category,
        sellerUid: sellerUid,
        quantity: quantity,
      );

  Map<String, dynamic> toMap() => {
        'productId': id,
        'title': title,
        'priceLabel': priceLabel,
        'image': image,
        'location': location,
        'category': category,
        'sellerUid': sellerUid,
        'quantity': quantity,
        'lineTotal': lineTotal,
      };
}
