import 'package:flutter/material.dart';
import '../data/product_dao.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int? _selectedProductId;

  void _goToDetail(int id) {
    setState(() {
      _selectedProductId = id;
      _selectedIndex = 1;
    });
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 1:
        return ProductDetailPage(productId: _selectedProductId ?? 0);
      case 2:
        return const Center(child: Text('Giỏ hàng (chưa có)'));
      default:
        return _buildHomePage();
    }
  }

  String _buildTitle() {
    if (_selectedIndex == 1 && _selectedProductId != null) {
      return ProductDAO.findProductById(_selectedProductId!)?.name ?? 'Product Detail';
    }
    switch (_selectedIndex) {
      case 2:  return 'Cart';
      default: return 'Product';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_buildTitle()),
        leading: _selectedIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedIndex = 0),
              )
            : null,
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(child: _buildProductList()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    final products = ProductDAO.getAllProduct();
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    if (isLandscape) {
      final cardWidth = (screenWidth - 12 * 3) / 2;
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 10,
          childAspectRatio: cardWidth / 110,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) => ProductCard(
          product: products[i],
          onTap: () => _goToDetail(products[i].id),
        ),
      );
    } else {
      final cardWidth = screenWidth - 24;
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => SizedBox(
          width: cardWidth,
          child: ProductCard(
            product: products[i],
            onTap: () => _goToDetail(products[i].id),
          ),
        ),
      );
    }
  }

  Widget _buildNavBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: 'Product Detail',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
      ],
    );
  }
}
