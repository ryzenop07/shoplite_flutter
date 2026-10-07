import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favourites_provider.dart';
import 'product_detail_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavouritesProvider>().favourites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favs.isEmpty
          ? const Center(child: Text('No favourites yet!'))
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final product = favs[index];
                return ListTile(
                  leading: Image.network(product.thumbnail,
                      width: 60, fit: BoxFit.cover),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: product),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
