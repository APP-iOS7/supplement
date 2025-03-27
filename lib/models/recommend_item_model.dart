class RecommendItemModel {
  String name;
  String caution;
  String functionality;
  List<String> ingredients;
  String mainEffect;
  String manufacturer;
  String dosageAndForm;
  String recommendedFor;
  String sideEffects;
  String storage;
  String price;
  double rating;
  String? imageLink;

  RecommendItemModel({
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
    required this.price,
    required this.rating,
    this.imageLink,
  });

  factory RecommendItemModel.fromJson(Map<String, dynamic> json) {
    return RecommendItemModel(
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
      price: json['price'],
      rating: json['rating'].toDouble(),
      imageLink: json['imageLink'],
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
      'price': price,
      'rating': rating,
      'imageLink': imageLink,
    };
  }
}
