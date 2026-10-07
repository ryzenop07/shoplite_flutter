import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/cart_provider.dart';
import 'product_detail_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavouritesProvider>().favourites;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text('Wishlist',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  if (favs.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${favs.length}',
                          style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
            Expanded(
              child: favs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_outline,
                              size: 80, color: theme.colorScheme.outline),
                          const SizedBox(height: 16),
                          Text('No favourites yet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.outline)),
                          const SizedBox(height: 8),
                          Text('Tap ❤️ on any product to save it!',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.outline)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: favs.length,
                      itemBuilder: (_, i) {
                        final product = favs[i];
                        final inCart = context
                            .watch<CartProvider>()
                            .inCart(product.id);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(
                                      product: product)),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    product.thumbnail,
                                    width: 75, height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 14),
                                          Text(
                                              ' ${product.rating.toStringAsFixed(1)}',
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.favorite,
                                          color: Colors.red, size: 20),
                                      onPressed: () => context
                                          .read<FavouritesProvider>()
                                          .toggleFavourite(product),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        inCart
                                            ? Icons.check_circle
                                            : Icons.add_shopping_cart,
                                        color: inCart
                                            ? Colors.green
                                            : theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                      onPressed: () => context
                                          .read<CartProvider>()
                                          .addToCart(product),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
