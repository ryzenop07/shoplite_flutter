import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favourites_provider.dart';
import 'product_detail_screen.dart';
import 'favourites_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts({String query = ''}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = query.isEmpty
          ? 'https://dummyjson.com/products?limit=20'
          : 'https://dummyjson.com/products/search?q=$query';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      setState(() {
        products = (data['products'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Something went wrong. Please try again.';
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    fetchProducts(query: value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopLite 🛍️'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavouritesScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 12),
            Text(errorMessage!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  fetchProducts(query: _searchController.text.trim()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFav = context
            .watch<FavouritesProvider>()
            .isFavourite(product.id);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.thumbnail,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(product.title,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('\$${product.price}',
                style: const TextStyle(color: Colors.deepPurple)),
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () => context
                  .read<FavouritesProvider>()
                  .toggleFavourite(product),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ),
            ),
          ),
        );
      },
    );
  }
}
