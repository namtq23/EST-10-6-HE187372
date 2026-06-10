import 'product.dart';

class ProductDAO {
  static final List<Product> _products = [
    Product(
      id: 1,
      name: 'Áo thun nam',
      price: 250000,
      discountPercent: 10,
      starNumber: 4.5,
      image: 'assets/images/ao_thun_nam.png',
    ),
    Product(
      id: 2,
      name: 'Quần jeans nữ',
      price: 450000,
      discountPercent: 20,
      starNumber: 4.0,
      image: 'assets/images/quan_jeans_nu.png',
    ),
    Product(
      id: 3,
      name: 'Giày sneaker',
      price: 800000,
      discountPercent: 15,
      starNumber: 4.8,
      image: 'assets/images/giay_sneaker.png',
    ),
    Product(
      id: 4,
      name: 'Túi xách da',
      price: 600000,
      discountPercent: 5,
      starNumber: 3.5,
      image: 'assets/images/tui_xach_da.png',
    ),
    Product(
      id: 5,
      name: 'Mũ lưỡi trai',
      price: 120000,
      discountPercent: 0,
      starNumber: 4.2,
      image: 'assets/images/mu_luoi_trai.png',
    ),
  ];

  static List<Product> getAllProduct() {
    return _products;
  }

  static List<Product> findProductByName(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return _products
        .where((p) => p.name.toLowerCase().contains(lowerKeyword))
        .toList();
  }

  static Product? findProductById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
