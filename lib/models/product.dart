class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String description;
  final String category;
  final double rating;
  final int stock;
  final double discountPercentage;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
    required this.category,
    required this.rating,
    required this.stock,
    required this.discountPercentage,
    required this.images,
  });

  double get discountedPrice =>
      price - (price * discountPercentage / 100);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      description: json['description'],
      category: json['category'],
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
