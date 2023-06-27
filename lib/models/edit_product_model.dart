class ProductTemp {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  ProductTemp({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
