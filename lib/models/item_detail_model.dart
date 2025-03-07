class ItemDetail {
  final String name;
  final String imageUrl;
  final String description;
  final List<String> ingredients;
  final String functionality;
  final String dosage;
  final String sideEffects;
  final String caution;
  final String manufacturer;
  final String price;
  final double rating;

  ItemDetail({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.functionality,
    required this.dosage,
    required this.sideEffects,
    required this.caution,
    required this.manufacturer,
    required this.price,
    required this.rating,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    return ItemDetail(
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      functionality: json['functionality'],
      dosage: json['dosage'],
      sideEffects: json['sideEffects'],
      caution: json['caution'],
      manufacturer: json['manufacturer'],
      price: json['price'],
      rating: json['rating'].toDouble(),
    );
  }
}
