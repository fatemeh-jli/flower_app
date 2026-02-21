class Flower {
  final String name;
  final String emoji;
  final int price;
  final String? imagePath;

  Flower({
    required this.name,
    required this.emoji,
    required this.price,
    this.imagePath,
  });
}