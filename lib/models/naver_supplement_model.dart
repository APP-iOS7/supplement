class SearchItem {
  final String title;
  final String link;
  final String image;
  final String lprice;
  final String? hprice;
  final String mallName;
  final String productId;
  final String productType;
  final String brand;
  final String? maker;
  final String category1;
  final String category2;
  final String category3;
  final String category4;

  SearchItem({
    required this.title,
    required this.link,
    required this.image,
    required this.lprice,
    this.hprice,
    required this.mallName,
    required this.productId,
    required this.productType,
    required this.brand,
    this.maker,
    required this.category1,
    required this.category2,
    required this.category3,
    required this.category4,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      title: json['title'],
      link: json['link'],
      image: json['image'],
      lprice: json['lprice'],
      hprice: json['hprice'],
      mallName: json['mallName'],
      productId: json['productId'],
      productType: json['productType'],
      brand: json['brand'],
      maker: json['maker'],
      category1: json['category1'],
      category2: json['category2'],
      category3: json['category3'],
      category4: json['category4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'image': image,
      'lprice': lprice,
      'hprice': hprice,
      'mallName': mallName,
      'productId': productId,
      'productType': productType,
      'brand': brand,
      'maker': maker,
      'category1': category1,
      'category2': category2,
      'category3': category3,
      'category4': category4,
    };
  }
}
