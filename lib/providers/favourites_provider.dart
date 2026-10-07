import 'package:flutter/material.dart';
import '../models/product.dart';

class FavouritesProvider extends ChangeNotifier {
  final List<Product> _favourites = [];

  List<Product> get favourites => _favourites;

  bool isFavourite(int id) => _favourites.any((p) => p.id == id);

  void toggleFavourite(Product product) {
    if (isFavourite(product.id)) {
      _favourites.removeWhere((p) => p.id == product.id);
    } else {
      _favourites.add(product);
    }
    notifyListeners();
  }
}
