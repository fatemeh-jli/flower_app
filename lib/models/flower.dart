class Flower {
  final String name;
  final String emoji; // مطمئن شوید این خط وجود دارد
  final int price;
  final String? imagePath;

  Flower({
    required this.name,
    required this.emoji, // مطمئن شوید این خط وجود دارد
    required this.price,
    this.imagePath,
  });
}