class GeminiAnswerModel {
  final String name;
  final String caution;
  final String functionality;
  final List<String> ingredients;
  final String mainEffect;
  final String manufacturer;
  final String dosageAndForm;
  final String recommendedFor;
  final String sideEffects;
  final String storage;
  final String imageLink;
  final String price;
  final double rating;

  GeminiAnswerModel({
    required this.name,
    required this.caution,
    required this.functionality,
    required this.ingredients,
    required this.mainEffect,
    required this.manufacturer,
    required this.dosageAndForm,
    required this.recommendedFor,
    required this.sideEffects,
    required this.storage,
    required this.imageLink,
    required this.price,
    required this.rating,
  });

  factory GeminiAnswerModel.fromJson(Map<String, dynamic> json) {
    return GeminiAnswerModel(
      name: json['name'],
      caution: json['caution'],
      functionality: json['functionality'],
      ingredients: List<String>.from(json['ingredients']),
      mainEffect: json['mainEffect'],
      manufacturer: json['manufacturer'],
      dosageAndForm: json['dosageAndForm'],
      recommendedFor: json['recommendedFor'],
      sideEffects: json['sideEffects'],
      storage: json['storage'],
      imageLink: json['imageLink'],
      price: json['price'],
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'caution': caution,
      'functionality': functionality,
      'ingredients': ingredients,
      'mainEffect': mainEffect,
      'manufacturer': manufacturer,
      'dosageAndForm': dosageAndForm,
      'recommendedFor': recommendedFor,
      'sideEffects': sideEffects,
      'storage': storage,
      'imageLink': imageLink,
      'price': price,
      'rating': rating,
    };
  }
}
