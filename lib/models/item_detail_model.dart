class ItemDetail {
  final String name;
  final String description;
  final List<String> ingredients;
  final String functionality;
  final String dosage;
  final String sideEffects;
  final String caution;
  final String manufacturer;
  final String price;
  final double rating;
  final List<String> reviews;

  ItemDetail({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.functionality,
    required this.dosage,
    required this.sideEffects,
    required this.caution,
    required this.manufacturer,
    required this.price,
    required this.rating,
    required this.reviews,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    return ItemDetail(
      name: json['name'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      functionality: json['functionality'],
      dosage: json['dosage'],
      sideEffects: json['sideEffects'],
      caution: json['caution'],
      manufacturer: json['manufacturer'],
      price: json['price'],
      rating: json['rating'].toDouble(),
      reviews: List<String>.from(json['reviews']),
    );
  }
}
