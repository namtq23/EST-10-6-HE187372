class Product {
  final int id;
  final String name;
  final double price;
  final double discountPercent;
  final double starNumber;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPercent,
    required this.starNumber,
    required this.image,
  });

  double get discountedPrice => price * (1 - discountPercent / 100);
}
