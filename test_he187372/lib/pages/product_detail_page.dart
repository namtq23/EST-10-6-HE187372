import 'package:flutter/material.dart';
import '../data/product.dart';
import '../data/product_dao.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = ProductDAO.findProductById(productId);

    if (product == null) {
      return const Center(child: Text('Không tìm thấy sản phẩm'));
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(context, product),
                _buildInfo(product),
                _buildPriceSection(product),
              ],
            ),
          ),
        ),
        _buildAddToCartButton(),
      ],
    );
  }

  // ─── Ảnh full width ───────────────────────────────────────────────────────
  Widget _buildImage(BuildContext context, Product product) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SizedBox(
          width: width,
          height: width * 0.7,
          child: Image.asset(
            product.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
            ),
          ),
        ),
        if (product.discountPercent > 0)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '-${product.discountPercent.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ─── Tên + sao ───────────────────────────────────────────────────────────
  Widget _buildInfo(Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(5, (i) {
                final full = i < product.starNumber.floor();
                final half = !full && i < product.starNumber;
                return Icon(
                  full
                      ? Icons.star
                      : (half ? Icons.star_half : Icons.star_border),
                  color: Colors.amber,
                  size: 20,
                );
              }),
              const SizedBox(width: 6),
              Text(
                product.starNumber.toStringAsFixed(1),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Giá ─────────────────────────────────────────────────────────────────
  Widget _buildPriceSection(Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 24),

          // Giá gốc + giá bán cạnh nhau
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPrice(product.discountedPrice),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  _formatPrice(product.price),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          if (product.discountPercent > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[100]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_offer_outlined, size: 15, color: Colors.red[700]),
                  const SizedBox(width: 6),
                  Text(
                    'Tiết kiệm: ${_formatPrice(product.price - product.discountedPrice)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Nút thêm vào giỏ ────────────────────────────────────────────────────
  Widget _buildAddToCartButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('Thêm vào giỏ hàng', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.deepPurple,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final str = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '$buffer đ';
  }
}
