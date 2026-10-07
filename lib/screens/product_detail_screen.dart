import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favourites_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavouritesProvider>();
    final isFav = favProvider.isFavourite(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null),
            onPressed: () => favProvider.toggleFavourite(product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(product.thumbnail, height: 220,
                  fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),
            Text(product.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('\$${product.price}',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(product.rating.toString(),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Chip(label: Text(product.category)),
            const SizedBox(height: 12),
            Text(product.description,
                style:
                    const TextStyle(fontSize: 15, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
