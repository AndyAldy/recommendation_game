class Game {
  final int id;
  final String name;
  final String? released;
  final double rating;
  final String? backgroundImage;

  Game({
    required this.id,
    required this.name,
    this.released,
    required this.rating,
    this.backgroundImage,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      released: json['released'],
      rating: (json['rating'] ?? 0).toDouble(),
      backgroundImage: json['background_image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'released': released,
      'rating': rating,
      'background_image': backgroundImage,
    };
  }
}