class CommodityPrice {
  final String name;
  final String price;

  CommodityPrice({required this.name, required this.price});

  factory CommodityPrice.fromJson(Map<String, dynamic> json) {
    return CommodityPrice(
      name: json['commodity'] ?? 'Unknown',
      price: json['modal_price'].toString(),
    );
  }
}
