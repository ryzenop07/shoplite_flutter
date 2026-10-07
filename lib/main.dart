import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/favourites_provider.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavouritesProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductListScreen(),
    );
  }
}
